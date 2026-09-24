# HabitFlow

![CI](https://github.com/OWNER/habit_flow/actions/workflows/ci.yml/badge.svg)
![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.3.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

A production-ready Flutter habit-tracking app: create habits, mark them
done each day, and see streaks and completion stats — in French or
English, light or dark.

> Replace `OWNER` in the badge URL above with your GitHub username/org
> once the repo is pushed, so the CI badge resolves correctly.

## Features

- **5 screens** — Home (habit list), Habit Detail, Add/Edit Habit,
  Statistics, Settings.
- **State management** — `provider` + `ChangeNotifier`, with a
  repository interface (`HabitRepository`) decoupling the UI from
  storage (`LocalHabitRepository` persists to `SharedPreferences` as
  JSON).
- **Pure business logic** — `StreakCalculator` computes current streak,
  best streak, and completion rate as free functions with no Flutter
  dependency, so it's cheap to test exhaustively.
- **Internationalization** — French and English via ARB files
  (`lib/l10n/app_en.arb`, `lib/l10n/app_fr.arb`) and
  `flutter_localizations`, including pluralized strings.
- **Accessibility** — `Semantics` labels on checkboxes, streak badges,
  the weekly-target slider, and heatmap cells.
- **Performance** — `ListView.builder` for lazy list rendering, `const`
  constructors throughout the widget tree, `ValueKey`s on list items so
  Flutter can diff efficiently, and `cached_network_image` with
  `memCacheWidth` for lazy-loaded, resolution-capped, disk-cached
  optional habit images.

## Architecture

```
lib/
  models/          Habit, HabitCategory — plain immutable data classes
  services/         StreakCalculator — pure business logic (no Flutter imports)
  repositories/      HabitRepository (interface), LocalHabitRepository (SharedPreferences)
  providers/         HabitProvider, SettingsProvider — ChangeNotifier state holders
  screens/            HomeScreen, HabitDetailScreen, AddEditHabitScreen, StatsScreen, SettingsScreen
  widgets/            HabitCard, StreakBadge, WeekHeatmap — small, const-friendly presentational widgets
  l10n/               app_en.arb, app_fr.arb — source of truth for translated strings
```

The layering is deliberate: `services/` and `repositories/` never
import Flutter/UI code, which is what makes the 30 unit tests fast and
independent of the widget tree. `providers/` is the only layer that
talks to both the domain layer and the UI.

## Getting started

```bash
# 1. Clone and fetch dependencies
git clone https://github.com/OWNER/habit_flow.git
cd habit_flow
flutter pub get

# 2. Generate platform folders (not checked into this repo)
flutter create .

# 3. Generate localization code (also runs automatically on `flutter run`/`build`)
flutter gen-l10n

# 4. Run the app
flutter run
```

Requires Flutter `>=3.3.0` (stable channel) and Dart `>=3.3.0`.

## Testing

```bash
# Unit + widget tests, with coverage
flutter test --coverage

# Integration tests (needs a connected device or emulator)
flutter test integration_test
```

| Layer       | Location                              | Count |
|-------------|----------------------------------------|-------|
| Unit        | `test/models/`, `test/services/`, `test/providers/`, `test/repositories/` | 31 |
| Widget      | `test/widgets/`                        | 13    |
| Integration | `integration_test/app_test.dart`       | 2     |

## CI/CD

`.github/workflows/ci.yml` runs on every push and pull request to
`main`:

1. `dart format --set-exit-if-changed` — formatting check.
2. `flutter analyze --fatal-infos` — static analysis, zero warnings
   tolerated.
3. `flutter test --coverage` — unit + widget suite, coverage uploaded
   as a build artifact.
4. `flutter test integration_test` on an Android emulator.
5. `flutter build apk --release` — demo APK uploaded as a build
   artifact for download from the Actions run.

## Screenshots

_Add screenshots here once the app is run locally, e.g.:_

```markdown
| Home | Detail | Add/Edit | Stats | Settings |
|------|--------|----------|-------|----------|
| ![home](docs/screenshots/home.png) | ![detail](docs/screenshots/detail.png) | ![add](docs/screenshots/add.png) | ![stats](docs/screenshots/stats.png) | ![settings](docs/screenshots/settings.png) |
```

## License

MIT — see [LICENSE](LICENSE).
