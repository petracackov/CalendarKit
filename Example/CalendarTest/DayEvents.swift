//
//  MockedData.swift
//  CalendarTest
//
//  Created by Petra Cackov on 27. 6. 26.
//

import Foundation

struct DayEvents: Identifiable {

    let id: UUID
    let events: [Event]
    let date: Date

    struct Event {

        let id: UUID
        let start: Date
        let endDate: Date
        let title: String

        static let mockEvents: [Event] = [
            .init(id: UUID(),
                  start: Date().app.startOfDay.app.addingHours(8),
                  endDate: Date().app.startOfDay.app.addingHours(10),
                  title: "Morning standup"),
            .init(id: UUID(),
                  start: Date().app.startOfDay.app.addingHours(11),
                  endDate: Date().app.startOfDay.app.addingHours(12).app.addingSeconds(1800),
                  title: "Product sync"),
            .init(id: UUID(),
                  start: Date().app.startOfDay.app.addingHours(12),
                  endDate: Date().app.startOfDay.app.addingHours(13),
                  title: "Lunch with team"),
            .init(id: UUID(),
                  start: Date().app.startOfDay.app.addingHours(14),
                  endDate: Date().app.startOfDay.app.addingHours(14).app.addingSeconds(15),
                  title: "Design review"),
            .init(id: UUID(),
                  start: Date().app.startOfDay.app.addingHours(16),
                  endDate: Date().app.startOfDay.app.addingHours(18),
                  title: "Focus block"),
            .init(id: UUID(),
                  start: Date().app.startOfDay.app.addingHours(19),
                  endDate: Date().app.startOfDay.app.addingHours(20),
                  title: "Fitness"),
        ]
    }

    static func mockedDays() -> [DayEvents] {
        guard let beginningOfTheMonth = Date().app.firstDayOfTheMonth else { return [ ] }
        return [
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(1)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(2)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(3)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(5)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(7)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(8)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(11)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(14)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(15)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(18)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(22)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(23)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(25)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(26)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(27)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(28)),
            .init(id: UUID(),
                  events: Event.mockEvents,
                  date: beginningOfTheMonth.app.addingDays(29)),
        ]
    }

}

extension Date {

    var app: App { App(date: self) }

    class App {
        private static let appCalendar: Calendar = {
            var calendar = Calendar.current
            calendar.firstWeekday = 2
            return calendar
        }()

        let date: Date

        init(date: Date) {
            self.date = date
        }

        private var calendar: Calendar {
            Self.appCalendar
        }

        func addingSeconds(_ secondsToAdd: Int) -> Date {
            return calendar.date(byAdding: .second, value: secondsToAdd, to: date) ?? date
        }

        func addingHours(_ hoursToAdd: Int) -> Date {
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: date) ?? date
        }

        func addingDays(_ daysToAdd: Int) -> Date {
            return calendar.date(byAdding: .day, value: daysToAdd, to: date) ?? date
        }

        var dayComponents: DateComponents {
            return calendar.dateComponents([.day, .weekday, .month, .year], from: date)
        }

        var startOfDay: Date {
            calendar.startOfDay(for: date)
        }

        var firstDayOfTheMonth: Date? {
            let currentDayComponents = dayComponents
            guard let currentMonth = currentDayComponents.month,
                  let currentYear = currentDayComponents.year,
                  let firstDayOfTheCurrentMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)) else { return nil }
            return firstDayOfTheCurrentMonth
        }

        func dayIsEqualTo(_ date: Date) -> Bool {
            let currentDay = calendar.dateComponents([.day, .month, .year], from: self.date)
            let day = calendar.dateComponents([.day, .month, .year], from: date)

            return day == currentDay
        }
    }
}
