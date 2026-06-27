//
//  AppDateFormatter.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import Foundation

class AppDateFormatter {

    @MainActor static let shared = AppDateFormatter()

    private let dateFormatter: DateFormatter = DateFormatter()

    let calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }()

    // Mark: - Formatter

    func fullDateString(date: Date) -> String {
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }

    func dateString(date: Date) -> String {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

    func monthYearToString(date: Date) -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    func dateWithWeekDayToString(date: Date) -> String {

        // Set Date Format
        dateFormatter.dateFormat = "EE. d.M"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    func timeToString(date: Date) -> String {
        // Set Date Format
        dateFormatter.dateFormat = "h:mm"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    func hoursToString(date: Date) -> String {
        // Set Date Format
        dateFormatter.dateFormat = "h a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    func localizedHourString(date: Date) -> String {
        // Set Date Format
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("jmm")

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    func secondsToString(secoonds: Int) -> String {
        let minutes = (secoonds/60) % 60
        let hours = (secoonds/3600)
        return "\(hours)h \(minutes)min"
    }

}
