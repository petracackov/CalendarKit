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
    private let mockEvents: [String] = [
        "08:30 Standup",
        "10:00 Product sync",
        "12:00 Lunch with team",
        "14:30 Design review",
        "16:00 Focus block"
    ]

    var body: some View {
        CalendarView(
            selectedMonth: $selectedMonth,
            onSelectedDate: { date in
                print(date)
            },
            dayContent: { _, context in
                eventsView(context)
            }
        )

    }

    private func eventsView(_ context: CalendarDayContentContext) -> some View {
        let maxRows = context.maxItems(itemHeight: 20, verticalSpacing: 2)
        let reservedRowsForMore = mockEvents.count > maxRows ? 1 : 0
        let eventRows = max(0, maxRows - reservedRowsForMore)
        let visibleEvents = Array(mockEvents.prefix(eventRows))
        let hiddenCount = max(0, mockEvents.count - visibleEvents.count)

        return VStack(alignment: .leading, spacing: 2) {
            ForEach(visibleEvents, id: \.self) { event in
                Text(event)
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
}

#Preview {
    ContentView()
}
