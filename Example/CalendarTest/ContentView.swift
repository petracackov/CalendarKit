//
//  ContentView.swift
//  CalendarTest
//
//  Created by Petra Cackov on 22. 3. 26.
//

import SwiftUI
import CalendarKit

struct ContentView: View {

    @State private var selectedMonth: MonthUi = MonthUi.currentMonth()
    @State private var selectedDay: DayEvents?
    let days = DayEvents.mockedDays()

    var body: some View {
        CalendarView(
            selectedMonth: $selectedMonth,
            onSelectedDate: { date in
                selectedDay = day(for: date)
            },
            dayContent: { date, context in
                Group {
                    if let day = day(for: date) {
                        eventsView(context, day: day)
                    } else {
                        EmptyView()
                    }
                }
            }
        )
        .fullScreenCover(item: $selectedDay) { day in
            NavigationStack {
                DayTimetableView(
                    style: .init(
                        tintColor: .clear,
                        fontColor: .gray,
                        timeIndicatorColor: Color.purple.opacity(0.3)
                    ),
                    intervals: toIntervals(day),
                    intervalContent: { interval in
                        dayView(eventId: interval.id, day: day)
                    })
                .navigationTitle("Timetable")
                .toolbar {
                    ToolbarItem {
                        Button("", systemImage: "xmark") {
                            selectedDay = nil
                        }
                    }
                }
            }
        }

    }

    private func eventsView(_ context: CalendarDayContentContext, day: DayEvents) -> some View {
        let maxRows = context.maxItems(itemHeight: 20, verticalSpacing: 2)
        let reservedRowsForMore = day.events.count > maxRows ? 1 : 0
        let eventRows = max(0, maxRows - reservedRowsForMore)
        let visibleEvents = Array(day.events.prefix(eventRows))
        let hiddenCount = max(0, day.events.count - visibleEvents.count)

        return VStack(alignment: .leading, spacing: 2) {
            ForEach(visibleEvents, id: \.self.id) { event in
                Text(event.title)
                    .frame(height: 20)
                    .lineLimit(1)
                    .font(.caption2)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }

            if hiddenCount > 0 {
                Text("+\(hiddenCount) more")
                    .frame(height: 20)
                    .lineLimit(1)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
    }

    @ViewBuilder
    private func dayView(eventId: UUID, day: DayEvents) -> some View {
        if let day = day.events.first(where: { $0.id == eventId }) {
            VStack {
                Text(day.title)
                    .font(.title)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.purple.opacity(0.3))
            .clipShape(.rect(cornerRadius: 20))
        }
    }

    private func day(for date: Date) -> DayEvents? {
        return days.first(where: { $0.date.app.dayIsEqualTo(date) })
    }

    private func toIntervals(_ day: DayEvents) -> [Interval] {
        day.events.map { Interval(id: $0.id, start: $0.start, end: $0.endDate) }
    }
}

#Preview {
    ContentView()
}
