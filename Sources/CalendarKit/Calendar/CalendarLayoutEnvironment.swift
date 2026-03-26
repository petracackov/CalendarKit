//
//  CalendarLayoutEnvironment.swift
//  CalendarTest
//
//  Created by Cursor on 25. 3. 26.
//

import SwiftUI
import Combine

class CalendarLayoutEnvironment: ObservableObject {
    enum Orientation {
        case portrait
        case landscape
    }

    @Published private(set) var containerSize: CGSize = .zero
    @Published private(set) var metrics: LayoutMetrics = .default
    @Published private(set) var orientation: Orientation = .portrait

    func updateLayout(for size: CGSize) {
        guard containerSize != size else { return }

        let landscape = size.width > size.height

        containerSize = size
        metrics = LayoutMetrics.forScreenSize(size)
        orientation = landscape ? .landscape : .portrait
    }
}
