import SwiftUI

struct OnboardingView: View {
    @Environment(AppStateManager.self) private var appState
    @State private var page = 0
    @State private var wakeUp = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? .now
    @State private var bedtime = Calendar.current.date(from: DateComponents(hour: 23, minute: 0)) ?? .now
    @State private var venmoUsername = ""

    private let totalPages = 4

    var body: some View {
        ZStack {
            FY.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    ForEach(0..<totalPages, id: \.self) { i in
                        Capsule()
                            .fill(i <= page ? FY.accent : FY.surface)
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, FY.spacingL)
                .padding(.top, FY.spacingM)

                TabView(selection: $page) {
                    welcomePage.tag(0)
                    schedulePage.tag(1)
                    venmoPage.tag(2)
                    permissionsPage.tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(duration: 0.4), value: page)
            }
        }
    }

    // MARK: - Page 1: Welcome

    private var welcomePage: some View {
        ScrollView {
            VStack(spacing: FY.spacingXL) {
                Spacer().frame(height: FY.spacingXL)

                Image("shield")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)

                VStack(spacing: FY.spacingS) {
                    Text("Ouch")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(FY.textPrimary)

                    Text("Break bad habits with\nreal consequences")
                        .font(.title3)
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Spacer().frame(height: FY.spacingM)

                VStack(spacing: FY.spacingM) {
                    featureRow(icon: "lock.fill", color: FY.accent, text: "Block social media during focus time")
                    featureRow(icon: "moon.fill", color: .purple, text: "Enforce a healthy sleep schedule")
                    featureRow(icon: "dollarsign.circle.fill", color: FY.danger, text: "Pay real money if you break the rules")
                }

                Spacer().frame(height: FY.spacingXL)

                nextButton("Get Started")
            }
            .padding(FY.spacingL)
        }
    }

    // MARK: - Page 2: Schedule

    private var schedulePage: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: FY.spacingL) {
                    VStack(spacing: FY.spacingS) {
                        Text("Set Your Schedule")
                            .font(.title.bold())
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textPrimary)
                        Text("When do you wake up and go to bed?")
                            .font(.subheadline)
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textSecondary)
                    }
                    .padding(.top, FY.spacingL)

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Wake Up", systemImage: "sunrise.fill")
                                .font(.headline)
                                .fontDesign(.rounded)
                                .foregroundStyle(FY.warning)
                            DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 120)
                                .clipped()
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Bedtime", systemImage: "moon.fill")
                                .font(.headline)
                                .fontDesign(.rounded)
                                .foregroundStyle(FY.accent)
                            DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 120)
                                .clipped()
                        }
                    }
                }
                .padding(.horizontal, FY.spacingL)
            }

            nextButton("Continue") {
                var schedule = appState.schedule
                schedule.wakeUpDate = wakeUp
                schedule.bedtimeDate = bedtime
                appState.schedule = schedule
            }
            .padding(FY.spacingL)
        }
    }

    // MARK: - Page 3: Venmo

    private var venmoPage: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: FY.spacingXL) {
                    Spacer().frame(height: FY.spacingXXL)

                    Image(systemName: "person.2.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(FY.accent)

                    VStack(spacing: FY.spacingS) {
                        Text("Accountability Partner")
                            .font(.title.bold())
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textPrimary)
                        Text("Who receives your penalty payments?\nEnter their Venmo username.")
                            .font(.subheadline)
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    GlassCard {
                        HStack {
                            Text("@")
                                .foregroundStyle(FY.textSecondary)
                                .font(.title2)
                                .fontDesign(.rounded)
                            TextField("venmo-username", text: $venmoUsername)
                                .textFieldStyle(.plain)
                                .font(.title2)
                                .fontDesign(.rounded)
                                .foregroundStyle(FY.textPrimary)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                    }

                    Text("$5 per unlock goes directly to them")
                        .font(.caption)
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textTertiary)
                }
                .padding(.horizontal, FY.spacingL)
            }

            nextButton("Continue") {
                appState.venmoUsername = venmoUsername
            }
            .disabled(venmoUsername.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(venmoUsername.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
            .padding(FY.spacingL)
        }
    }

    // MARK: - Page 4: Permissions (non-blocking)

    private var permissionsPage: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: FY.spacingXL) {
                    Spacer().frame(height: FY.spacingXL)

                    Image("lock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    VStack(spacing: FY.spacingS) {
                        Text("Almost Done")
                            .font(.title.bold())
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textPrimary)
                        Text("These permissions help Ouch\nkeep you on track.")
                            .font(.subheadline)
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: FY.spacingM) {
                        permissionButton(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Wake-up alarms & reminders"
                        ) {
                            NotificationService.requestPermission()
                        }

                        permissionButton(
                            icon: "hourglass",
                            title: "Screen Time",
                            subtitle: "Block distracting apps"
                        ) {
                            ScreenTimeManager.shared.requestAuthorization()
                        }
                    }

                    Text("You can set these up later in Settings too.")
                        .font(.caption)
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, FY.spacingL)
            }

            ActionButton(
                title: "Let's Go!",
                icon: "arrow.right",
                gradient: FY.accentGradient,
                isLarge: true
            ) {
                NotificationService.scheduleMorningAlarm(
                    hour: appState.schedule.wakeUpHour,
                    minute: appState.schedule.wakeUpMinute
                )
                NotificationService.scheduleBedtimeReminder(
                    hour: appState.schedule.bedtimeHour,
                    minute: appState.schedule.bedtimeMinute
                )
                withAnimation(.spring(duration: 0.5)) {
                    appState.hasCompletedOnboarding = true
                }
            }
            .padding(FY.spacingL)
        }
    }

    // MARK: - Helpers

    private func featureRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: FY.spacingM) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 36)
            Text(text)
                .font(.subheadline)
                .fontDesign(.rounded)
                .foregroundStyle(FY.textSecondary)
            Spacer()
        }
        .padding(.horizontal, FY.spacingM)
    }

    private func nextButton(_ title: String, action: (() -> Void)? = nil) -> some View {
        ActionButton(
            title: title,
            icon: "arrow.right",
            gradient: FY.accentGradient,
            isLarge: true
        ) {
            action?()
            withAnimation(.spring(duration: 0.4)) {
                page += 1
            }
        }
    }

    private func permissionButton(
        icon: String, title: String, subtitle: String, action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: FY.spacingM) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(FY.accent)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textTertiary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(FY.textTertiary)
            }
            .padding(FY.spacingM)
            .background(
                RoundedRectangle(cornerRadius: FY.radiusM, style: .continuous)
                    .fill(FY.card)
                    .shadow(color: FY.cardShadow, radius: 6, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
        .environment(AppStateManager())
}
