# Changelog

All notable changes to HabitFlow are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.2] - 2026-09-24
### Fixed
- Removed a dangling `assets/icons/` declaration in `pubspec.yaml`.
  The directory was empty and unused (all icons come from Material's
  built-in `Icons` set), and git doesn't track empty directories, so it
  vanished on push and `flutter analyze` failed on the missing path.

## [1.0.1] - 2026-09-23
### Fixed
- **Race condition in `HabitProvider`**: a mutation (`addHabit`,
  `updateHabit`, `deleteHabit`, `toggleDay`) issued immediately after the
  provider is lazily constructed — before its initial `load()` had
  resolved — could be silently overwritten once `load()` completed with
  its now-stale snapshot. Mutating methods now await the in-flight
  initial load first. Added a regression test.
- `StreakBadge` semantics label was merging with its child `Text`
  widget's own semantics node (e.g. producing `"3 day streak\n3"`
  instead of `"3 day streak"`). Fixed with `container: true` +
  `excludeSemantics: true`.
- Removed unnecessary `!` null-assertions on `AppLocalizations.of(context)`
  (non-nullable per `l10n.yaml`'s `nullable-getter: false`), flagged by
  `flutter analyze`.
- Replaced the default `test/widget_test.dart` template (referencing a
  nonexistent `MyApp`, added automatically by `flutter create .`) with a
  real smoke test for `HabitFlowApp`.

## [1.0.0] - 2026-09-23
### Added
- Full production-ready release: 5 screens (Home, Habit Detail, Add/Edit
  Habit, Statistics, Settings).
- Accessibility: semantic labels on all interactive elements (checkboxes,
  streak badges, sliders, heatmap cells).
- Internationalization: French and English via ARB files and
  `flutter_localizations`.
- GitHub Actions CI: format check, `flutter analyze --fatal-infos`,
  unit/widget tests with coverage, integration tests on an Android
  emulator, and a release APK build.
- Full test suite: 30 unit tests, 13 widget tests, 2 integration tests.

### Changed
- Switched `HabitCard` to `cached_network_image` with `memCacheWidth` so
  optional habit cover images are lazy-loaded, disk-cached, and decoded
  at display resolution instead of full size.

## [0.2.0] - 2026-09-10
### Added
- `SettingsProvider` for persisted locale and theme mode, with a
  dedicated Settings screen (language + theme segmented controls).
- `StatsScreen` showing aggregate stats (total habits, best streak,
  overall completion rate).
- `WeekHeatmap` widget visualizing the last 7 days per habit.

### Fixed
- `StreakCalculator.currentStreak` no longer breaks the streak when
  "today" isn't marked done yet but yesterday's chain is intact.

## [0.1.0] - 2026-08-28
### Added
- Initial project scaffold: `Habit` model, `HabitRepository` /
  `LocalHabitRepository` (SharedPreferences-backed), `HabitProvider`
  state management.
- Home screen with habit list, add/edit habit form, and habit detail
  screen.
- `StreakCalculator` pure business-logic service with initial unit
  test coverage.
