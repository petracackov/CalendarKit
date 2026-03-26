//
//  CalendarLayoutMetrics.swift
//  CalendarTest
//
//  Created by Cursor on 25. 3. 26.
//

import SwiftUI

struct LayoutMetrics {
    let headerHorizontalPadding: CGFloat
    let headerBottomPadding: CGFloat
    let navigationSpacing: CGFloat
    let dayNumberFontSize: CGFloat
    let dayNumberBadgeSize: CGFloat
    let dayNumberTopPadding: CGFloat
    let dayNumberHorizontalPadding: CGFloat
    let dayCellMinHeight: CGFloat
    let weekdayFont: Font
    let monthNameFont: Font
    let yearFont: Font
    let navigationFont: Font

    static let `default` = LayoutMetrics(
        headerHorizontalPadding: 16,
        headerBottomPadding: 16,
        navigationSpacing: 16,
        dayNumberFontSize: 12,
        dayNumberBadgeSize: 20,
        dayNumberTopPadding: 3,
        dayNumberHorizontalPadding: 3,
        dayCellMinHeight: 60,
        weekdayFont: .caption,
        monthNameFont: .title,
        yearFont: .title2,
        navigationFont: .body
    )

    static func forScreenSize(_ size: CGSize) -> LayoutMetrics {
        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        let isLandscape = size.width > size.height
        let compactWidth = min(size.width, size.height) < 380

        switch userInterfaceIdiom {
        case .pad:
            return .init(
                headerHorizontalPadding: isLandscape ? 28 : 24,
                headerBottomPadding: isLandscape ? 16 : 20,
                navigationSpacing: 24,
                dayNumberFontSize: isLandscape ? 16 : 15,
                dayNumberBadgeSize: isLandscape ? 28 : 26,
                dayNumberTopPadding: 6,
                dayNumberHorizontalPadding: 6,
                dayCellMinHeight: isLandscape ? 90 : 96,
                weekdayFont: .headline,
                monthNameFont: .largeTitle,
                yearFont: .title,
                navigationFont: .headline
            )
        case .phone:
            return .init(
                headerHorizontalPadding: compactWidth ? 12 : 16,
                headerBottomPadding: isLandscape ? 12 : 16,
                navigationSpacing: compactWidth ? 12 : 16,
                dayNumberFontSize: compactWidth ? 11 : 12,
                dayNumberBadgeSize: compactWidth ? 18 : 20,
                dayNumberTopPadding: compactWidth ? 2 : 3,
                dayNumberHorizontalPadding: compactWidth ? 2 : 3,
                dayCellMinHeight: isLandscape ? 44 : 60,
                weekdayFont: compactWidth ? .caption2 : .caption,
                monthNameFont: compactWidth ? .title2 : .title,
                yearFont: compactWidth ? .title3 : .title2,
                navigationFont: compactWidth ? .callout : .body
            )
        case .tv, .carPlay, .mac, .vision, .unspecified:
            return .default
        @unknown default:
            return .default
        }
    }
}
