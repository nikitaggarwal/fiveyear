import SwiftUI
#if canImport(FamilyControls)
import FamilyControls
#endif

struct SettingsView: View {
    @Environment(AppStateManager.self) private var appState
    @State private var showAppPicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: FY.spacingL) {

                    // MARK: - Accountability Partner

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Venmo Partner", systemImage: "person.2.fill")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.accent)

                            Text("Penalty payments go to this person")
                                .font(.caption).fontDesign(.rounded)
                                .foregroundStyle(FY.textTertiary)

                            HStack {
                                Text("@")
                                    .foregroundStyle(FY.textSecondary)
                                    .font(.title3).fontDesign(.rounded)
                                TextField(
                                    "username",
                                    text: Binding(
                                        get: { appState.venmoUsername },
                                        set: { appState.venmoUsername = $0 }
                                    )
                                )
                                .textFieldStyle(.plain)
                                .font(.title3).fontDesign(.rounded)
                                .foregroundStyle(FY.textPrimary)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: FY.radiusS, style: .continuous)
                                    .fill(FY.surface)
                            )
                        }
                    }

                    // MARK: - Penalty Amount

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Penalty Amount", systemImage: "dollarsign.circle.fill")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.danger)

                            HStack(spacing: FY.spacingS) {
                                ForEach([1, 5, 10, 20, 50], id: \.self) { amount in
                                    let isSelected = Int(appState.penaltyAmount) == amount
                                    Button {
                                        withAnimation(.spring(duration: 0.3)) {
                                            appState.penaltyAmount = Double(amount)
                                        }
                                    } label: {
                                        Text("$\(amount)")
                                            .font(.subheadline.bold()).fontDesign(.rounded)
                                            .foregroundStyle(isSelected ? .white : FY.textSecondary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: FY.radiusS, style: .continuous)
                                                    .fill(isSelected ? FY.danger : FY.surface)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    // MARK: - Unlock Duration

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Unlock Duration", systemImage: "timer")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            HStack {
                                Text("\(appState.unlockDurationMinutes) min")
                                    .font(.title3.bold()).fontDesign(.rounded)
                                    .foregroundStyle(FY.textPrimary)
                                    .frame(width: 70, alignment: .leading)

                                Slider(
                                    value: Binding(
                                        get: { Double(appState.unlockDurationMinutes) },
                                        set: { appState.unlockDurationMinutes = Int($0) }
                                    ),
                                    in: 1...30, step: 1
                                )
                                .tint(FY.accent)
                            }
                        }
                    }

                    // MARK: - Screen Time

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Blocked Apps", systemImage: "apps.iphone")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.accent)

                            Text("Select which apps to block during focus time and bedtime.")
                                .font(.caption).fontDesign(.rounded)
                                .foregroundStyle(FY.textTertiary)

                            if ScreenTimeManager.shared.isAuthorized {
                                HStack(spacing: FY.spacingS) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(FY.success)
                                    Text("Screen Time authorized")
                                        .font(.subheadline).fontDesign(.rounded)
                                        .foregroundStyle(FY.success)
                                }
                            } else {
                                Button {
                                    ScreenTimeManager.shared.requestAuthorization()
                                } label: {
                                    HStack {
                                        if ScreenTimeManager.shared.isRequestingAuth {
                                            ProgressView()
                                                .tint(.white)
                                        } else {
                                            Image(systemName: "hand.raised.fill")
                                        }
                                        Text("Authorize Screen Time")
                                    }
                                    .font(.subheadline.bold()).fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: FY.radiusS, style: .continuous)
                                            .fill(FY.accent)
                                    )
                                }
                                .buttonStyle(.plain)
                                .disabled(ScreenTimeManager.shared.isRequestingAuth)
                            }

                            if let error = ScreenTimeManager.shared.authError {
                                Text(error)
                                    .font(.caption).fontDesign(.rounded)
                                    .foregroundStyle(FY.danger)
                            }

                            Button {
                                showAppPicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "checklist")
                                    Text("Select Apps to Block")
                                }
                                .font(.subheadline.bold()).fontDesign(.rounded)
                                .foregroundStyle(ScreenTimeManager.shared.isAuthorized ? FY.accent : FY.textTertiary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: FY.radiusS, style: .continuous)
                                        .stroke(
                                            (ScreenTimeManager.shared.isAuthorized ? FY.accent : FY.textTertiary).opacity(0.4),
                                            lineWidth: 1
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(!ScreenTimeManager.shared.isAuthorized)
                        }
                    }
                    #if canImport(FamilyControls)
                    .familyActivityPicker(
                        isPresented: $showAppPicker,
                        selection: Bindable(ScreenTimeManager.shared).activitySelection
                    )
                    .onChange(of: ScreenTimeManager.shared.activitySelection) {
                        ScreenTimeManager.shared.applyShields()
                    }
                    #endif

                    // MARK: - About

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingS) {
                            Label("About Ouch", systemImage: "info.circle")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            Text(
                                "Ouch helps you stay focused by blocking distracting apps and adding real financial consequences. Build better habits, one day at a time."
                            )
                            .font(.caption).fontDesign(.rounded)
                            .foregroundStyle(FY.textTertiary)
                        }
                    }
                }
                .padding(FY.spacingL)
            }
            .navigationTitle("Settings")
            .fyBackground()
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppStateManager())
}
