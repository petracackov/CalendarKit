# Changelog

All notable changes to this project are documented in this file.

## [1.1.3] - 2026-06-28

### Added

- Added adaptive `DayTimetableView` interval content with `largeContent`, `midContent`, and `smallContent` closures for short and long events.
- Added current-time indicator styling through `currentTimeIndicatorColor` and `indicatorFontColor`.

### Changed

- Updated `DayTimetableView` usage to pass the represented `date`, enabling today-aware current-time behavior and initial scrolling.
- Renamed timetable interval background styling to `intervalColor`.

## [1.1.2] - 2026-06-27

### Fixed

- Fixed timetable interval positioning to calculate from the interval's own day.

## [1.1.1] - 2026-06-27

### Changed

- Cleaned up timetable implementation and example app data.

## [1.1.0] - 2026-06-27

### Added

- Added `DayTimetableView` for rendering a scrollable 24-hour day timetable.
- Added `Interval` for timetable items with start and end dates.
- Added `TimetableStyle` for customizing timetable interval tint, time labels, and time indicators.

## [1.0.2] - 2026-03-31

### Fixed

- Fixed month quarter calculation.

## [1.0.1] - 2026-03-26

### Changed

- Cleaned up package implementation.

## [1.0.0] - 2026-03-26

### Changed

- Made model properties public for package consumers.

## [0.1.0] - 2026-03-26

First public version of CalendarKit.

[1.1.3]: https://github.com/petracackov/CalendarKit/releases/tag/1.1.3
[1.1.2]: https://github.com/petracackov/CalendarKit/releases/tag/1.1.2
[1.1.1]: https://github.com/petracackov/CalendarKit/releases/tag/1.1.1
[1.1.0]: https://github.com/petracackov/CalendarKit/releases/tag/1.1.0
[1.0.2]: https://github.com/petracackov/CalendarKit/releases/tag/1.0.2
[1.0.1]: https://github.com/petracackov/CalendarKit/releases/tag/1.0.1
[1.0.0]: https://github.com/petracackov/CalendarKit/releases/tag/1.0.0
[0.1.0]: https://github.com/petracackov/CalendarKit/releases/tag/v0.1.0
