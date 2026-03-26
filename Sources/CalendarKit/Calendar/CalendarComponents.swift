//
//  CalendarComponents.swift
//  CalendarTest
//
//  Created by Petra Cackov on 25. 3. 26.
//

import Foundation

public enum WeekDay: Int, CaseIterable, Identifiable {

    public var id: Self { self }

    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
    case sun = 1

    var shortName: String {
        switch self {
        case .mon: return "Mon"
        case .tue: return "Tue"
        case .wed: return "Wed"
        case .thu: return "Thu"
        case .fri: return "Fri"
        case .sat: return "Sat"
        case .sun: return "Sun"
        }
    }

    var offset: Int {
        switch self {
        case .mon: 0
        case .tue: 1
        case .wed: 2
        case .thu: 3
        case .fri: 4
        case .sat: 5
        case .sun: 6
        }
    }
}

public enum MonthName: Int, CaseIterable, Identifiable, Hashable {

    public var id: Self { self }

    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12

    var full: String {
        switch self {
        case .january: return "January"
        case .february: return "February"
        case .march: return "March"
        case .april: return "April"
        case .may: return "May"
        case .june: return "June"
        case .july: return "July"
        case .august: return "August"
        case .september: return "September"
        case .october: return "October"
        case .november: return "November"
        case .december: return "December"
        }
    }
}

public enum DayUi: Hashable {
    case value(Date), placeholder

    public var day: Int? {
        switch self {
        case .value(let date): date.app.dayComponents.day
        case .placeholder: nil
        }
    }

    public var isToday: Bool {
        switch self {
        case .placeholder: false
        case .value(let date): date.app.dayIsEqualTo(Date())
        }
    }

    public var dayString: String {
        guard let day else { return "" }
        return String(day)
    }
}

public struct MonthUi: Hashable, Identifiable {
    public let id: Int
    private let dates: [Date]
    public let weeks: [[DayUi]]

    public var monthComponents: DateComponents {
        dates.first?.app.monthComponents ?? Date().app.monthComponents
    }
    public var isCurrentMonth: Bool {
        monthComponents.date.app.isInCurrentMonth
    }

    public var name: MonthName {
        let month = dates.first?.app.dayComponents.month ?? 0
        return .init(rawValue: month) ?? .january
    }

    public init(id: Int, dates: [Date]) {
        self.id = id
        self.dates = dates
        self.weeks = Self.groupDates(dates)
    }

    static func groupDates(_ dates: [Date]) -> [[DayUi]] {
        guard let firstDay = dates.first,
              let weekday = firstDay.app.dayComponents.weekday,
              let startIndex = WeekDay(rawValue: weekday)?.offset else {
            return []
        }

        let prefix = 7-startIndex
        let firstWeek = dates.prefix(prefix).map { DayUi.value($0) }
        let emptyDates = Array(repeating: DayUi.placeholder, count: startIndex)

        let restOfTheDates = dates.suffix(dates.count-prefix).map { DayUi.value($0) }


        let suffixEmptyCount = 7 - ((emptyDates + firstWeek + restOfTheDates).count % 7)
        let suffixEmptyDates = suffixEmptyCount < 7 ? Array(repeating: DayUi.placeholder, count: suffixEmptyCount) : []

        let allDates = emptyDates + firstWeek + restOfTheDates + suffixEmptyDates

        let chunked = stride(from: 0, to: allDates.count, by: 7).map {
            Array(allDates[$0..<min($0 + 7, allDates.count)])
        }

        return chunked

    }

    public static func generateMonths() -> [MonthUi] {
        let months = (0...240).map { index in
            let monthsToAdd = index-120
            let dates = Date().app.addingMonths(monthsToAdd).app.datesInMonth
            return MonthUi(id: index, dates: dates)
        }
        return months
    }

    public static func currentMonth() -> MonthUi {
        let allMonths = generateMonths()
        let current = allMonths.first(where: { $0.isCurrentMonth }) ??  MonthUi(id: 0, dates: [])
        return current
    }

}
