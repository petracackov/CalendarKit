//
//  Date+Calendar.swift
//  BloodyBrilliant
//
//  Created by Petra Cackov on 10. 10. 24.
//

import Foundation

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

        func addingMonths(_ monthsToAdd: Int) -> Date {
            return calendar.date(byAdding: .month, value: monthsToAdd, to: date) ?? date
        }

        func addingYears(_ yearsToAdd: Int) -> Date {
            return calendar.date(byAdding: .year, value: yearsToAdd, to: date) ?? date
        }

        func dayIsEqualTo(_ date: Date) -> Bool {
            let currentDay = calendar.dateComponents([.day, .month, .year], from: self.date)
            let day = calendar.dateComponents([.day, .month, .year], from: date)

            return day == currentDay
        }

        func weekDayIsEqualTo(_ date: Date) -> Bool {
            return dayComponents.weekday == date.app.dayComponents.weekday
        }

        var allComponents: DateComponents {
            return calendar.dateComponents([.hour, .minute, .second, .day, .weekday, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .month, .isLeapMonth, .quarter, .year], from: date)
        }

        var yearComponents: DateComponents {
            return calendar.dateComponents([.year], from: date)
        }

        var monthComponents: DateComponents {
            return calendar.dateComponents([.month, .isLeapMonth, .year], from: date)
        }

        var weekComponents: DateComponents {
            return calendar.dateComponents([.weekOfMonth, .weekOfYear, .yearForWeekOfYear, .month, .year], from: date)
        }

        var dayComponents: DateComponents {
            return calendar.dateComponents([.day, .weekday, .month, .year], from: date)
        }

        var timeComponents: DateComponents {
            return calendar.dateComponents([.hour, .minute, .second], from: date)
        }

        var firstDayOfTheMonth: Date? {
            let currentDayComponents = dayComponents
            guard let currentMonth = currentDayComponents.month,
                  let currentYear = currentDayComponents.year,
                  let firstDayOfTheCurrentMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)) else { return nil }
            return firstDayOfTheCurrentMonth
        }

        var isInCurrentMonth: Bool {
            monthComponents == Date().app.monthComponents
        }

        var firstDayOfTheWeek: Date {
            calendar.date(from: date.app.weekComponents) ?? Date()
        }

        var startOfDay: Date {
            calendar.startOfDay(for: date)
        }

        var endOfDay: Date {
            startOfDay.app.addingDays(1).app.addingSeconds(-1)
        }

        var lastDayOfTheMonth: Date {
            firstDayOfTheMonth?.app.addingMonths(1).app.startOfDay.app.addingSeconds(-1) ?? Date()
        }

        func isBetween(_ start: Date, and end: Date) -> Bool {
            start <= date && date < end
        }

        func days(until date: Date) -> Int {
            calendar.dateComponents([.day], from: self.date, to: date).day ?? 0
        }

        var datesInMonth: [Date] {
            guard let firstDayOfTheMonth = firstDayOfTheMonth else { return [] }
            guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfTheMonth)?.count else { return [] }
            let days = Array(0..<numberOfDaysInMonth).compactMap { calendar.date(byAdding: .day, value: $0, to: firstDayOfTheMonth) }
            return days
        }

        var isFirstDayOfMonth: Bool {
            dayComponents == firstDayOfTheMonth?.app.dayComponents
        }
    }

}
