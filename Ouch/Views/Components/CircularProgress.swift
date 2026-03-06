import SwiftUI

struct CircularProgress: View {
    let progress: Double
    var lineWidth: CGFloat = 10
    var size: CGFloat = 200
    var trackColor: Color = FY.surface
    var progressColor: Color = FY.accent

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(duration: 0.6), value: progress)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    CircularProgress(progress: 0.65)
        .fyBackground()
}
