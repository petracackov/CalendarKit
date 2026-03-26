//
//  CalendarDayContentContext.swift
//  CalendarTest
//
//  Created by Cursor on 25. 3. 26.
//

import CoreGraphics

public struct CalendarDayContentContext: Sendable {
    let availableSize: CGSize

    public var availableWidth: CGFloat {
        availableSize.width
    }

    public var availableHeight: CGFloat {
        availableSize.height
    }

    public func maxItems(itemHeight: CGFloat, verticalSpacing: CGFloat = 0) -> Int {
        guard itemHeight > 0 else { return 0 }
        let rowHeight = itemHeight + verticalSpacing
        guard rowHeight > 0 else { return 0 }
        let visibleRows = (availableHeight + verticalSpacing) / rowHeight
        return max(0, Int(visibleRows))
    }

    static let zero = CalendarDayContentContext(availableSize: .zero)
}
