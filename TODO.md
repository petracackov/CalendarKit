# CalendarTest TODO

## Tasks

1. Resize properties based on the device (iPad, iPhone) and on orientation/screen size.
2. Use a sliding window.
3. Make this a package.
4. Add a week view when user changes iPhone orientation.
5. Add localization for titles, dates, and weekday names.
6. Handle safe 

## Remaining for Task 1 (responsive sizing)

- Validate and tune iPad edge cases (split view, stage manager, wide landscape).
- Reduce hardcoded sizing assumptions by deriving more values from measured container/layout context.
- Decouple day-content sizing calculations from internal calendar layout details.
- Define a stable parent API contract for day-content available size per device/orientation.
- Verify paging animations remain smooth while geometry/layout updates occur.

## Sliding Window Technical Docs

### Use a center date instead of indices

```swift
@State private var centerDate = Date()
@State private var months: [MonthUi] = []
@State private var selectedIndex: Int = 120 // middle of window
```

### Generate a window around the center

```swift
func generateMonths(center: Date) -> [MonthUi] {
    let calendar = Calendar.current

    return (-120...120).compactMap { offset in
        guard let date = calendar.date(byAdding: .month, value: offset, to: center) else {
            return nil
        }
        return MonthUi(id: offset, date: date)
    }
}
```

### Setup TabView

```swift
TabView(selection: $selectedIndex) {
    ForEach(months.indices, id: \.self) { index in
        monthView(months[index])
            .tag(index)
    }
}
.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
```

### Detect when user hits edge

```swift
.onChange(of: selectedIndex) { index in
    let threshold = 20

    if index < threshold || index > months.count - threshold {
        shiftWindow()
    }
}
```

### Shift the window

```swift
func shiftWindow() {
    let calendar = Calendar.current

    // Move center to currently visible month
    let visibleMonth = months[selectedIndex]
    centerDate = visibleMonth.date

    // Regenerate around new center
    months = generateMonths(center: centerDate)

    // Reset selection back to middle
    selectedIndex = months.count / 2
}
```
