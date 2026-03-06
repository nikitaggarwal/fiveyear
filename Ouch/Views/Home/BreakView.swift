import SwiftUI

// MARK: - Custom Animated Hourglass

struct AnimatedHourglass: View {
    let progress: Double

    private let sandColor = Color(red: 0.92, green: 0.73, blue: 0.35)
    private let sandDarkColor = Color(red: 0.82, green: 0.60, blue: 0.22)
    private let glassStroke = Color(red: 0.50, green: 0.44, blue: 0.38).opacity(0.55)
    private let rimColor = Color(red: 0.58, green: 0.50, blue: 0.42).opacity(0.45)
    private let highlightColor = Color.white.opacity(0.25)

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                draw(in: &ctx, size: size, time: t)
            }
        }
    }

    // MARK: - Geometry

    private struct G {
        let w, h, cx: CGFloat
        let rimH: CGFloat = 8
        let topY, botY, midY: CGFloat
        let glassHW, neckHW, chamberH: CGFloat

        init(_ size: CGSize) {
            w = size.width; h = size.height; cx = w / 2
            topY = 8; botY = h - 8; midY = h / 2
            glassHW = w * 0.38
            neckHW = w * 0.032
            chamberH = midY - topY
        }
    }

    private func topChamber(_ g: G) -> Path {
        Path { p in
            p.move(to: .init(x: g.cx - g.glassHW, y: g.topY))
            p.addLine(to: .init(x: g.cx + g.glassHW, y: g.topY))
            p.addCurve(
                to: .init(x: g.cx + g.neckHW, y: g.midY),
                control1: .init(x: g.cx + g.glassHW, y: g.midY - g.chamberH * 0.28),
                control2: .init(x: g.cx + g.neckHW, y: g.midY - g.chamberH * 0.08)
            )
            p.addLine(to: .init(x: g.cx - g.neckHW, y: g.midY))
            p.addCurve(
                to: .init(x: g.cx - g.glassHW, y: g.topY),
                control1: .init(x: g.cx - g.neckHW, y: g.midY - g.chamberH * 0.08),
                control2: .init(x: g.cx - g.glassHW, y: g.midY - g.chamberH * 0.28)
            )
            p.closeSubpath()
        }
    }

    private func botChamber(_ g: G) -> Path {
        Path { p in
            p.move(to: .init(x: g.cx - g.neckHW, y: g.midY))
            p.addLine(to: .init(x: g.cx + g.neckHW, y: g.midY))
            p.addCurve(
                to: .init(x: g.cx + g.glassHW, y: g.botY),
                control1: .init(x: g.cx + g.neckHW, y: g.midY + g.chamberH * 0.08),
                control2: .init(x: g.cx + g.glassHW, y: g.midY + g.chamberH * 0.28)
            )
            p.addLine(to: .init(x: g.cx - g.glassHW, y: g.botY))
            p.addCurve(
                to: .init(x: g.cx - g.neckHW, y: g.midY),
                control1: .init(x: g.cx - g.glassHW, y: g.midY + g.chamberH * 0.28),
                control2: .init(x: g.cx - g.neckHW, y: g.midY + g.chamberH * 0.08)
            )
            p.closeSubpath()
        }
    }

    // MARK: - Drawing

    private func draw(in ctx: inout GraphicsContext, size: CGSize, time: Double) {
        let g = G(size)
        let p = min(max(progress, 0), 1)
        let flowing = p > 0.005 && p < 0.995

        drawTopSand(in: &ctx, g: g, progress: p, flowing: flowing)
        drawBotSand(in: &ctx, g: g, size: size, progress: p, flowing: flowing)
        drawStream(in: &ctx, g: g, progress: p, flowing: flowing)
        drawGrains(in: &ctx, g: g, flowing: flowing, time: time, progress: p)
        drawGlass(in: &ctx, g: g, size: size)
    }

    private func drawTopSand(in ctx: inout GraphicsContext, g: G, progress p: Double, flowing: Bool) {
        guard p < 0.995 else { return }
        var c = ctx
        c.clip(to: topChamber(g))
        let surface = g.topY + g.chamberH * p
        let dip: CGFloat = flowing ? min(8, g.chamberH * (1 - p) * 0.12) : 0
        var sand = Path()
        sand.move(to: .init(x: 0, y: surface))
        sand.addQuadCurve(
            to: .init(x: g.w, y: surface),
            control: .init(x: g.cx, y: surface + dip)
        )
        sand.addLine(to: .init(x: g.w, y: g.midY + 2))
        sand.addLine(to: .init(x: 0, y: g.midY + 2))
        sand.closeSubpath()
        c.fill(sand, with: .color(sandColor))

        var darker = Path()
        darker.move(to: .init(x: g.cx - g.neckHW * 3, y: g.midY - 2))
        darker.addQuadCurve(
            to: .init(x: g.cx + g.neckHW * 3, y: g.midY - 2),
            control: .init(x: g.cx, y: g.midY - 8)
        )
        darker.addLine(to: .init(x: g.cx + g.neckHW * 3, y: g.midY + 2))
        darker.addLine(to: .init(x: g.cx - g.neckHW * 3, y: g.midY + 2))
        darker.closeSubpath()
        c.fill(darker, with: .color(sandDarkColor.opacity(0.4)))
    }

    /// Approximate half-width of the bottom chamber at a given Y
    private func botChamberHW(at y: CGFloat, _ g: G) -> CGFloat {
        let t = (y - g.midY) / (g.botY - g.midY)
        let clamped = min(max(t, 0), 1)
        // Matches the cubic Bezier curve shape: stays narrow near neck then opens
        let eased = pow(clamped, 0.55)
        return g.neckHW + (g.glassHW - g.neckHW) * eased
    }

    private func botSandMetrics(_ g: G, progress p: Double, flowing: Bool) -> (flatY: CGFloat, coneH: CGFloat) {
        let flatY = g.botY - g.chamberH * p
        let roomAbove = flatY - g.midY
        let maxConeH = g.chamberH * 0.28
        let coneFade = p > 0.85 ? max(0, (1 - p) / 0.15) : 1.0
        let coneH: CGFloat = flowing ? min(maxConeH, roomAbove * 0.7) * coneFade : 0
        return (flatY, coneH)
    }

    private func drawBotSand(in ctx: inout GraphicsContext, g: G, size: CGSize, progress p: Double, flowing: Bool) {
        guard p > 0.005 else { return }
        var c = ctx
        c.clip(to: botChamber(g))

        let (flatY, coneH) = botSandMetrics(g, progress: p, flowing: flowing)
        let wallHW = botChamberHW(at: flatY, g)

        var sand = Path()
        // Start at the left glass wall at the flat sand level
        sand.move(to: .init(x: g.cx - wallHW, y: flatY))
        // Slope up to the cone peak
        sand.addLine(to: .init(x: g.cx, y: flatY - coneH))
        // Slope down to the right glass wall
        sand.addLine(to: .init(x: g.cx + wallHW, y: flatY))
        // Fill down to the bottom
        sand.addLine(to: .init(x: size.width, y: g.botY + 2))
        sand.addLine(to: .init(x: 0, y: g.botY + 2))
        sand.closeSubpath()
        c.fill(sand, with: .color(sandColor))

        // Shading on right side of cone for depth
        if coneH > 3 {
            var shade = Path()
            shade.move(to: .init(x: g.cx, y: flatY - coneH))
            shade.addLine(to: .init(x: g.cx + wallHW, y: flatY))
            shade.addLine(to: .init(x: g.cx, y: flatY))
            shade.closeSubpath()
            c.fill(shade, with: .color(sandDarkColor.opacity(0.2)))
        }
    }

    private func drawStream(in ctx: inout GraphicsContext, g: G, progress p: Double, flowing: Bool) {
        guard flowing else { return }
        let topSurface = g.topY + g.chamberH * p
        let (flatY, coneH) = botSandMetrics(g, progress: p, flowing: flowing)
        let streamTop = max(topSurface, g.midY - g.chamberH * 0.15)
        let streamBot = flatY - coneH
        guard streamBot > streamTop else { return }

        let topW: CGFloat = 5.0
        let botW: CGFloat = 3.0
        var stream = Path()
        stream.move(to: .init(x: g.cx - topW / 2, y: streamTop))
        stream.addLine(to: .init(x: g.cx + topW / 2, y: streamTop))
        stream.addLine(to: .init(x: g.cx + botW / 2, y: streamBot))
        stream.addLine(to: .init(x: g.cx - botW / 2, y: streamBot))
        stream.closeSubpath()
        ctx.fill(stream, with: .color(sandColor))
    }

    private func drawGrains(in ctx: inout GraphicsContext, g: G, flowing: Bool, time: Double, progress p: Double) {
        guard flowing else { return }
        var c = ctx
        c.clip(to: botChamber(g))

        let (flatY, coneH) = botSandMetrics(g, progress: p, flowing: flowing)
        let coneTip = flatY - coneH

        // Grains that splash outward from the cone tip
        for i in 0..<20 {
            let seed = Double(i) * 2.39996322
            let period = 0.7 + seed.truncatingRemainder(dividingBy: 0.5)
            let phase = ((time / period) + seed).truncatingRemainder(dividingBy: 1.0)

            // Parabolic arc: grains launch from cone tip and arc outward/downward
            let angle = seed * 1.37 // launch direction
            let vx = CGFloat(sin(angle)) * 18
            let vy: CGFloat = -8 // initial upward velocity
            let gravity: CGFloat = 30
            let t = CGFloat(phase)

            let gx = g.cx + vx * t + CGFloat(sin(time * 1.5 + seed * 2.7)) * 2
            let gy = coneTip + vy * t + 0.5 * gravity * t * t

            guard gy < flatY + 4 else { continue }
            let sz: CGFloat = 1.8 + CGFloat(seed.truncatingRemainder(dividingBy: 0.8)) * 1.0
            let alpha = (1 - phase) * 0.8
            guard alpha > 0.05 else { continue }
            c.fill(
                Path(ellipseIn: CGRect(x: gx - sz / 2, y: gy - sz / 2, width: sz, height: sz)),
                with: .color(sandColor.opacity(alpha))
            )
        }
    }

    private func drawGlass(in ctx: inout GraphicsContext, g: G, size: CGSize) {
        var outline = topChamber(g)
        outline.addPath(botChamber(g))
        ctx.stroke(outline, with: .color(glassStroke), lineWidth: 2.5)

        let rimExtra: CGFloat = 5
        let topRim = Path(roundedRect: CGRect(
            x: g.cx - g.glassHW - rimExtra, y: 0,
            width: (g.glassHW + rimExtra) * 2, height: g.rimH
        ), cornerRadius: 3)
        let botRim = Path(roundedRect: CGRect(
            x: g.cx - g.glassHW - rimExtra, y: g.botY,
            width: (g.glassHW + rimExtra) * 2, height: g.rimH
        ), cornerRadius: 3)
        ctx.fill(topRim, with: .color(rimColor))
        ctx.fill(botRim, with: .color(rimColor))
        ctx.stroke(topRim, with: .color(glassStroke), lineWidth: 1)
        ctx.stroke(botRim, with: .color(glassStroke), lineWidth: 1)

        let hlOffset: CGFloat = g.glassHW * 0.35
        var hl = Path()
        hl.move(to: .init(x: g.cx - hlOffset, y: g.topY + 6))
        hl.addCurve(
            to: .init(x: g.cx - g.neckHW * 1.5, y: g.midY - 4),
            control1: .init(x: g.cx - hlOffset, y: g.midY - g.chamberH * 0.3),
            control2: .init(x: g.cx - g.neckHW * 1.5, y: g.midY - g.chamberH * 0.1)
        )
        ctx.stroke(hl, with: .color(highlightColor), lineWidth: 1.5)

        var hl2 = Path()
        hl2.move(to: .init(x: g.cx - g.neckHW * 1.5, y: g.midY + 4))
        hl2.addCurve(
            to: .init(x: g.cx - hlOffset, y: g.botY - 6),
            control1: .init(x: g.cx - g.neckHW * 1.5, y: g.midY + g.chamberH * 0.1),
            control2: .init(x: g.cx - hlOffset, y: g.midY + g.chamberH * 0.3)
        )
        ctx.stroke(hl2, with: .color(highlightColor), lineWidth: 1.5)
    }
}

// MARK: - Break View

struct BreakView: View {
    let unlockEnd: Date
    let now: Date

    @Environment(AppStateManager.self) private var appState

    private var secondsRemaining: Int {
        max(Int(unlockEnd.timeIntervalSince(now)), 0)
    }

    private var progress: Double {
        let total = Double(appState.unlockDurationMinutes) * 60
        guard total > 0 else { return 0 }
        return 1.0 - Double(secondsRemaining) / total
    }

    private var timeRemainingText: String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return m > 0 ? "\(m)m \(s)s" : "\(s)s"
    }

    var body: some View {
        VStack(spacing: FY.spacingL) {
            Spacer()

            AnimatedHourglass(progress: progress)
                .frame(width: 180, height: 260)

            VStack(spacing: FY.spacingS) {
                Text(timeRemainingText)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(FY.textPrimary)
                    .contentTransition(.numericText())

                Text("remaining")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }

            VStack(spacing: FY.spacingXS) {
                Text("On Break")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(FY.textPrimary)

                Text("apps unblocked temporarily")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }

            Spacer()

            Text("-$\(Int(appState.penaltyAmount))")
                .font(.title2.bold()).fontDesign(.rounded)
                .foregroundStyle(FY.danger)
                .padding(.horizontal, FY.spacingL)
                .padding(.vertical, FY.spacingS)
                .background(Capsule().fill(FY.danger.opacity(0.1)))

            Spacer().frame(height: FY.spacingXXL)
        }
    }
}

#Preview {
    BreakView(unlockEnd: Date.now.addingTimeInterval(300), now: .now)
        .fyBackground()
        .environment(AppStateManager())
}
