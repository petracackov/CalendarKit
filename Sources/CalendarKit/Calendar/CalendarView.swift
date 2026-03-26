//
//  CalendarView.swift
//  CalendarTest
//
//  Created by Petra Cackov on 23. 3. 26.
//

import SwiftUI

public struct CalendarView<DayContent: View>: View {
    @State private var months: [MonthUi] = MonthUi.generateMonths()

    @Binding var selectedMonth: MonthUi
    var style: CalendarStyle = .default
    let onSelectedDate: (Date) -> Void
    let dayContent: (Date, CalendarDayContentContext) -> DayContent

    @StateObject private var layout = CalendarLayoutEnvironment()
    @State private var monthSize: CGSize = .zero

    public init(
        selectedMonth: Binding<MonthUi>,
        style: CalendarStyle = .default,
        onSelectedDate: @escaping (Date) -> Void,
        dayContent: @escaping (Date, CalendarDayContentContext) -> DayContent
    ) {
        self._selectedMonth = selectedMonth
        self.style = style
        self.onSelectedDate = onSelectedDate
        self.dayContent = dayContent
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                titleSection()
                Spacer()
                navigationSection()
            }
            .padding(.horizontal, layout.metrics.headerHorizontalPadding)
            .padding(.bottom, layout.metrics.headerBottomPadding)

            HStack {
                ForEach(WeekDay.allCases) { weekday in
                    Text(weekday.shortName)
                        .font(layout.metrics.weekdayFont)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(style.fontColor)
                }
            }

            TabView(selection: $selectedMonth) {
                ForEach(months) { month in
                    monthView(month)
                        .tag(month)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                self.monthSize = newValue
                layout.updateLayout(for: newValue)
            }
        }
        .animation(.easeInOut, value: selectedMonth)
    }

}

private extension CalendarView {

    func titleSection() -> some View {
        HStack(spacing: 10) {
            Text(selectedMonth.name.full)
                .font(layout.metrics.monthNameFont)
                .fontWeight(.bold)
                .foregroundStyle(style.fontColor)
            if let year = selectedMonth.monthComponents.year {
                Text(String(year))
                    .font(layout.metrics.yearFont)
                    .foregroundStyle(style.fontColor)
            }
        }
    }

    func navigationSection() -> some View {
        HStack(spacing: layout.metrics.navigationSpacing) {
            navigationButton(.back)

            Button("Today") {
                guard let currentMonth = months.first(where: { $0.isCurrentMonth }) else { return }
                self.selectedMonth = currentMonth
            }
            .font(layout.metrics.navigationFont)
            .tint(style.tintColor)

            navigationButton(.next)
        }
    }

    func navigationButton(_ navigation: Navigation) -> some View {
        Button {
            goTo(navigation)
        } label: {
            Image(systemName: navigation.icon)
                .font(layout.metrics.navigationFont)
        }
        .tint(style.tintColor)
    }

    func monthView(_ month: MonthUi) -> some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(Array(month.weeks.enumerated()), id: \.offset) { _, week in
                GridRow {
                    ForEach(Array(week.enumerated()), id: \.offset) { _, item in
                        dayView(item)
                    }
                }
            }
        }
    }

    func dayView(_ item: DayUi) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(item.dayString)
                    .font(.system(size: layout.metrics.dayNumberFontSize))
                    .foregroundStyle(style.fontColor)
                    .frame(width: layout.metrics.dayNumberBadgeSize, height: layout.metrics.dayNumberBadgeSize)
                    .background(item.isToday ? style.tintColor.opacity(0.2) : .clear)
                    .clipShape(.circle)
            }
            .padding(.top, layout.metrics.dayNumberTopPadding)
            .padding(.horizontal, layout.metrics.dayNumberHorizontalPadding)


            switch item {
            case .value(let date):
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .topLeading) {
                        dayContent(date, dayContentContext())
                    }
                    .clipped()
            case .placeholder:
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, minHeight: layout.metrics.dayCellMinHeight, maxHeight: .infinity)
        .border(style.borderColor, width: 1)
        .contentShape(.rect)
        .onTapGesture {
            switch item {
            case .placeholder:
                return
            case .value(let date):
                onSelectedDate(date)
            }

        }
    }


}

/// Mark: - Logic
private extension CalendarView {

    func goTo(_ navigation: Navigation) {
        let currentIndex = months.firstIndex(of: selectedMonth) ?? 0
        switch navigation {
        case .next:
            guard currentIndex < months.count-1 else { return }
            selectedMonth = months[currentIndex+1]
        case .back:
            guard currentIndex > 0 else { return }
            selectedMonth = months[currentIndex-1]
        }
    }

    func dayContentContext() -> CalendarDayContentContext {
        let weekCount = selectedMonth.weeks.count
        guard weekCount > 0 else { return .zero }
        let buffer = 2.0
        let widthPerDay = layout.containerSize.width / 7 - buffer
        let headerHeight = layout.metrics.dayNumberTopPadding + layout.metrics.dayNumberBadgeSize
        let availableHeight = monthSize.height/CGFloat(weekCount) - headerHeight - buffer
        return .init(availableSize: .init(width: widthPerDay, height: availableHeight))
    }

    enum Navigation {
        case next
        case back

        var icon: String {
            switch self {
            case .next: "chevron.right"
            case .back: "chevron.left"
            }
        }
    }
}



#Preview {
    CalendarView(
        selectedMonth: .constant(.init(id: 0, dates: Date().app.datesInMonth)),
        onSelectedDate: { _ in },
        dayContent: { _, _ in Spacer() })
    .environmentObject(CalendarLayoutEnvironment())
}
