//
//  CalendarStyle.swift
//  CalendarTest
//
//  Created by Cursor on 25. 3. 26.
//

import SwiftUI

public struct CalendarStyle: Sendable {
    public let tintColor: Color
    public let fontColor: Color
    public let borderColor: Color

    public init(tintColor: Color, fontColor: Color, borderColor: Color) {
        self.tintColor = tintColor
        self.fontColor = fontColor
        self.borderColor = borderColor
    }

    public static let `default` = CalendarStyle(
        tintColor: .blue,
        fontColor: .black,
        borderColor: .gray.opacity(0.3)
    )
}
