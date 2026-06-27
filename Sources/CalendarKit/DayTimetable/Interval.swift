//
//  Interval.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import Foundation

public struct Interval: Identifiable {
    public let id: String
    public let start: Date
    public let end: Date

    var duration: Int {
        start.app.seconds(until: end)
    }

    public init(id: String = UUID().uuidString, start: Date, end: Date) {
        self.id = id
        self.start = start
        self.end = end
    }

}
