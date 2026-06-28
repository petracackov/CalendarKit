//
//  DayTimetableView.swift
//  CalendarKit
//
//  Created by Petra Cackov on 27. 6. 26.
//

import SwiftUI

public struct DayTimetableView<LargeContent: View, MidContent: View, SmallContent: View>: View {

    let hours: [String] = {
        Array(0...23).map { hour in
            let date = Date().app.startOfDay.app.addingHours(hour)
            return AppDateFormatter.shared.localizedHourString(date: date)
        }
    }()

    @State private var size: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var hourWidth: CGFloat = .zero
    @State private var scrolledID: String?
    @State private var didScrollInitially = false

    private var intervalAvailableWidth: CGFloat {
        max(size.width - hourWidth, 0)
    }

    private let date: Date
    private let style: TimetableStyle
    private let intervals: [[Interval]]
    private let largeContent: (Interval) -> LargeContent
    private let midContent: (Interval) -> MidContent
    private let smallContent: (Interval) -> SmallContent

    public init(date: Date,
                style: TimetableStyle = .default,
                intervals: [Interval],
                @ViewBuilder largeContent: @escaping (Interval) -> LargeContent,
                @ViewBuilder midContent: @escaping (Interval) -> MidContent,
                @ViewBuilder smallContent: @escaping (Interval) -> SmallContent) {
        self.intervals = Self.combineIntervals(intervals)
        self.largeContent = largeContent
        self.midContent = midContent
        self.smallContent = smallContent
        self.style = style
        self.date = date
    }

    public init(date: Date,
                style: TimetableStyle = .default,
                intervals: [Interval],
                @ViewBuilder intervalContent: @escaping (Interval) -> LargeContent) where MidContent == LargeContent, SmallContent == LargeContent {
        self.intervals = Self.combineIntervals(intervals)
        self.date = date
        self.largeContent = intervalContent
        self.midContent = intervalContent
        self.smallContent = intervalContent
        self.style = style
    }

    public var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(hours, id: \.self) { hour in
                        VStack(spacing: 0) {
                            hourSeparator(for: hour)
                            Spacer()
                        }
                        .frame(height: size.height/6)
                        .id(hour)
                    }


                    hourSeparator(for: hours.first ?? "")

                }

                ForEach(Array(intervals.enumerated()), id: \.offset) { subinterval in
                    subintervalView(for: subinterval.element)
                }

                if date.app.dayIsEqualTo(Date()) {
                    currentHourIndicator()
                }

            }
            .scrollTargetLayout()
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                self.contentSize = newValue
                scrollToInitialPositionIfNeeded()
            }
        }
        .scrollPosition(id: $scrolledID, anchor: .top)
        .safeAreaPadding(.vertical, 30)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            self.size = newValue
            scrollToInitialPositionIfNeeded()
        }

    }

    private func currentHourIndicator() -> some View {
        TimelineView(.periodic(from: .now, by: 5)) { timeline in
            HStack(spacing: 0) {
                Text(AppDateFormatter.shared.localizedHourString(date: timeline.date))
                    .font(.caption)
                    .padding(3)
                    .frame(width: hourWidth)
                    .foregroundStyle(style.indicatorFontColor)
                    .background(style.currentTimeIndicatorColor)
                    .clipShape(.capsule)
                    .padding(.leading, 5)

                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(style.currentTimeIndicatorColor)
            }
            .offset(y: dateToPixels(timeline.date))
        }
    }

    private func hourSeparator(for hour: String) -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(style.timeIndicatorColor)
            .padding(.leading, hourWidth)
            .overlay(alignment: .leading) {
                Text(hour)
                    .padding(.leading, 15)
                    .foregroundStyle(style.fontColor)
                    .font(.caption)
                    .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
                    } action: { newValue in
                        self.hourWidth = max(newValue.width + 5, self.hourWidth)
                    }
            }
    }


    private func subintervalView(for intervals: [Interval]) -> some View {
        let indices = Array(intervals.indices)

        return ForEach(indices, id: \.self) { (offset: Int) in
            let interval = intervals[offset]

            ZStack {
                ViewThatFits(in: .vertical) {
                    largeContent(interval)
                    midContent(interval)
                    smallContent(interval)
                }
            }
            .background(style.intervalColor)
            .frame(width: intervalWidth(index: intervals.count),
                   height: intervalToPixels(interval))
            .offset(x: CGFloat(offset)*intervalWidth(index: intervals.count)+hourWidth,
                    y: dateToPixels(interval.start))
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
        let startToPixels = dateToPixels(interval.start)
        let durationCap = contentSize - startToPixels
        return max(min(durationCap, durationInPixels), 20)
    }

    private func dateToPixels(_ date: Date) -> CGFloat {
        let start = date.timeIntervalSince(
            date.app.startOfDay)
        let ratio = start/(60 * 60 * 24)
        let startInPixels = ratio*contentSize.height
        return startInPixels
    }

    private func scrollToInitialPositionIfNeeded() {
        guard !didScrollInitially,
              size.height > 0,
              contentSize.height > size.height else { return }

        let firstInterval = intervals
            .flatMap { $0 }
            .min(by: { $0.start < $1.start })
        let hour = if date.app.dayIsEqualTo(Date()) {
            Date().app.timeComponents.hour ?? 8
        } else {
            firstInterval?.start.app.timeComponents.hour ?? 8
        }

        let initialScrollID = hours.indices.contains(hour) ? hours[hour] : nil

        didScrollInitially = true
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            scrolledID = initialScrollID
        }
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
    DayTimetableView(
        date: Date(),
        intervals: [
            .init(id: UUID().uuidString, start: Date().app.startOfDay, end: Date().app.startOfDay.app.addingMinutes(5)),
            .init(id: UUID().uuidString, start: Date().app.startOfDay.app.addingHours(1), end: Date().app.startOfDay.app.addingHours(3)),
            .init(id: UUID().uuidString, start: Date().app.startOfDay.app.addingHours(4), end: Date().app.startOfDay.app.addingHours(5)),
            .init(id: UUID().uuidString, start: Date().app.startOfDay.app.addingHours(23), end: Date().app.startOfDay.app.addingHours(25))
        ], largeContent: { interval in
            VStack {
                Text(interval.id)
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }, midContent: { interval in
            Text(interval.id)
                .lineLimit(1)
        }, smallContent: { interval in
            Text(interval.id)
                .lineLimit(1)
        })
}
