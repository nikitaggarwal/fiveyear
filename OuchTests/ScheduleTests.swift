import Testing
@testable import Ouch

@Suite("Schedule Logic")
struct ScheduleTests {

    @Test("Default schedule has correct values")
    func defaultSchedule() {
        let s = Schedule()
        #expect(s.wakeUpHour == 7)
        #expect(s.wakeUpMinute == 0)
        #expect(s.bedtimeHour == 23)
        #expect(s.bedtimeMinute == 0)
        #expect(s.gracePeriodMinutes == 10)
        #expect(s.focusBlocks.isEmpty)
    }

    @Test("Focus block formats time range correctly")
    func focusBlockTimeRange() {
        let block = FocusBlock(name: "Deep Work", startHour: 9, startMinute: 0, endHour: 12, endMinute: 30)
        #expect(block.formattedTimeRange == "9:00 AM – 12:30 PM")
    }

    @Test("Focus block formats PM time correctly")
    func focusBlockPMTime() {
        let block = FocusBlock(name: "Afternoon", startHour: 14, startMinute: 0, endHour: 17, endMinute: 0)
        #expect(block.formattedTimeRange == "2:00 PM – 5:00 PM")
    }

    @Test("Time state is free outside all blocks")
    func freeTimeState() {
        let appState = AppStateManager()
        appState.hasConfirmedAwakeToday = true
        var schedule = Schedule()
        schedule.wakeUpHour = 7
        schedule.bedtimeHour = 23
        schedule.focusBlocks = [
            FocusBlock(name: "Work", startHour: 9, startMinute: 0, endHour: 12, endMinute: 0)
        ]
        appState.schedule = schedule

        // 1 PM should be free
        let cal = Calendar.current
        if let date = cal.date(from: DateComponents(hour: 13, minute: 0)) {
            let state = appState.currentTimeState(at: date)
            #expect(state == .free)
        }
    }

    @Test("Time state is focus during a focus block")
    func focusTimeState() {
        let appState = AppStateManager()
        appState.hasConfirmedAwakeToday = true
        var schedule = Schedule()
        schedule.wakeUpHour = 7
        schedule.bedtimeHour = 23
        let today = Calendar.current.component(.weekday, from: .now)
        schedule.focusBlocks = [
            FocusBlock(
                name: "Work",
                startHour: 9, startMinute: 0,
                endHour: 12, endMinute: 0,
                activeDays: Set([today])
            )
        ]
        appState.schedule = schedule

        let cal = Calendar.current
        if let date = cal.date(from: DateComponents(hour: 10, minute: 30)) {
            let state = appState.currentTimeState(at: date)
            #expect(state == .focus(blockName: "Work", endHour: 12, endMinute: 0))
        }
    }
}
