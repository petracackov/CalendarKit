//
//  File.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import SwiftUI

public struct TimetableStyle: Sendable {
    public let tintColor: Color
    public let fontColor: Color
    public let timeIndicatorColor: Color

    public init(tintColor: Color, fontColor: Color, timeIndicatorColor: Color) {
        self.tintColor = tintColor
        self.fontColor = fontColor
        self.timeIndicatorColor = timeIndicatorColor
    }

    public static let `default` = TimetableStyle(
        tintColor: .blue.opacity(0.3),
        fontColor: .black,
        timeIndicatorColor: .gray.opacity(0.3)
    )
}
