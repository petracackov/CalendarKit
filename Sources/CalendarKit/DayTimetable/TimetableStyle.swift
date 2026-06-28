//
//  File.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import SwiftUI

public struct TimetableStyle: Sendable {
    public let intervalColor: Color
    public let fontColor: Color
    public let timeIndicatorColor: Color
    public let currentTimeIndicatorColor: Color
    public let indicatorFontColor: Color

    public init(intervalColor: Color,
                fontColor: Color,
                timeIndicatorColor: Color,
                currentTimeIndicatorColor: Color,
                indicatorFontColor: Color) {
        self.intervalColor = intervalColor
        self.fontColor = fontColor
        self.timeIndicatorColor = timeIndicatorColor
        self.currentTimeIndicatorColor = currentTimeIndicatorColor
        self.indicatorFontColor = indicatorFontColor
    }

    public static let `default` = TimetableStyle(
        intervalColor: .blue.opacity(0.3),
        fontColor: .black,
        timeIndicatorColor: .gray.opacity(0.3),
        currentTimeIndicatorColor: .gray,
        indicatorFontColor: .white
    )
}
