//
//  DayTimetableView.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import SwiftUI

public struct DayTimetableView<Content: View>: View {

    let hours: [String] = {
        Array(0...23).map { hour in
            let date = Date().app.startOfDay.app.addingHours(hour)
            return AppDateFormatter.shared.localizedHourString(date: date)
        }
    }()

    @State private var size: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var hourWidth: CGFloat = .zero

    private var intervalAvailableWidth: CGFloat {
        max(size.width - hourWidth, 0)
    }

    private let style: TimetableStyle
    private let intervals: [[Interval]]
    private let intervalContent: (Interval) -> Content

    public init(style: TimetableStyle = .default,
                intervals: [Interval],
                intervalContent: @escaping (Interval) -> Content) {
        self.intervals = Self.combineIntervals(intervals)
        self.intervalContent = intervalContent
        self.style = style
    }

    public var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(hours, id: \.self) { hour in
                        hourView(for: hour)
                    }
                }

                ForEach(Array(intervals.enumerated()), id: \.offset) { subinterval in
                    subintervalView(for: subinterval.element)
                }

            }
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                self.contentSize = newValue
            }
        }
        .safeAreaPadding(.top, 30)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            self.size = newValue
        }

    }

    private func hourView(for hour: String) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(style.timeIndicatorColor)
                .padding(.leading, hourWidth)
                .overlay(alignment: .leading) {
                    Text(hour)
                        .padding(.leading, 5)
                        .foregroundStyle(style.fontColor)
                        .font(.caption)
                        .onGeometryChange(for: CGSize.self) { proxy in
                            proxy.size
                        } action: { newValue in
                            self.hourWidth = max(newValue.width + 5, self.hourWidth)
                        }
                }
            Spacer()
        }
        .frame(height: size.height/6)
    }


    private func subintervalView(for intervals: [Interval]) -> some View {
        ForEach(Array(intervals.enumerated()), id: \.offset,) { offset, interval in
            intervalContent(interval)
                .background(style.tintColor)
                .frame(width: intervalWidth(index: intervals.count),
                       height: intervalToPixels(interval))
                .clipped()
                .offset(x: CGFloat(offset)*intervalWidth(index: intervals.count)+hourWidth,
                        y: startToPixels(interval))

        }
    }

}

// MARK: Calculations

extension DayTimetableView {

    private func intervalWidth(index: Int) -> CGFloat {
        return intervalAvailableWidth/CGFloat(index)
    }

    private func intervalToPixels(_ interval: Interval) -> CGFloat {
        let duration = CGFloat(interval.duration)
        let contentSize = contentSize.height
        let ratio = duration/(60 * 60 * 24)
        let durationInPixels = ratio*contentSize
        let startToPixels = startToPixels(interval)
        let durationCap = contentSize - startToPixels
        return min(durationCap, durationInPixels)
    }

    private func startToPixels(_ interval: Interval) -> CGFloat {
        let start = interval.start.timeIntervalSince(Date().app.startOfDay)
        let ratio = start/(60 * 60 * 24)
        let startInPixels = ratio*contentSize.height
        return startInPixels
    }

    static func combineIntervals(_ intervals: [Interval]) -> [[Interval]] {
        var combined: [[Interval]] = []
        let sorted = intervals.sorted(by: { $0.start < $1.start })

        var subinterval: [Interval] = []
        for interval in sorted {
            if let lastInterval = subinterval.last {
                if lastInterval.end > interval.start {
                    subinterval.append(interval)
                } else {
                    combined.append(subinterval)
                    subinterval = [interval]
                }
            } else {
                subinterval.append(interval)
            }
        }

        combined.append(subinterval)

        return combined
    }
}

#Preview {
    DayTimetableView(intervals: [
        .init(id: UUID().uuidString, start: Date().app.startOfDay, end: Date().app.startOfDay.app.addingHours(2)),
        .init(id: UUID().uuidString, start: Date().app.startOfDay.app.addingHours(1), end: Date().app.startOfDay.app.addingHours(3)),
        .init(id: UUID().uuidString, start: Date().app.startOfDay.app.addingHours(4), end: Date().app.startOfDay.app.addingHours(5))
    ]) { interval in
        VStack {
            Text(interval.id)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
