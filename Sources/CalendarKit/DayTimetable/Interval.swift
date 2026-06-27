//
//  Interval.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import Foundation

public struct Interval: Identifiable {
    public let id: UUID
    public let start: Date
    public let end: Date

    public init(id: UUID = UUID(), start: Date, end: Date) {
        self.id = id
        self.start = start
        self.end = end
    }

    var duration: Int {
        print("ww", start.app.seconds(until: end))
        return start.app.seconds(until: end)
    }
}
