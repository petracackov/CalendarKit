import XCTest
@testable import CalendarKit

final class CalendarKitTests: XCTestCase {
    func testGenerateMonthsHasExpectedRange() {
        let months = MonthUi.generateMonths()
        XCTAssertEqual(months.count, 241)
        XCTAssertEqual(months.first?.id, 0)
        XCTAssertEqual(months.last?.id, 240)
    }

    func testMonthGroupingCreatesFullWeeks() {
        // March 2026 starts on Sunday. With Monday-first calendar this should produce 6 rows.
        let components = DateComponents(year: 2026, month: 3, day: 1)
        let month = MonthUi(id: 0, dates: components.date.app.datesInMonth)

        XCTAssertEqual(month.weeks.count, 6)
        XCTAssertTrue(month.weeks.allSatisfy { $0.count == 7 })
    }

    func testDayContentContextMaxItems() {
        let context = CalendarDayContentContext(availableSize: CGSize(width: 100, height: 64))
        XCTAssertEqual(context.maxItems(itemHeight: 20, verticalSpacing: 2), 3)
        XCTAssertEqual(context.maxItems(itemHeight: 0, verticalSpacing: 2), 0)
    }
}
