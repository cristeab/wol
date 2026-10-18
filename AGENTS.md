# Repository Guidelines

## Project Structure & Module Organization

This is a Qt 6 desktop/mobile Wake-on-LAN application. C++ implementation and headers live in `src/`; QML views and reusable UI components are in `qml/`; images, icons, and other packaged resources are in `img/` and `ios/`. `qml.qrc` registers resources, while `CMakeLists.txt` defines the Qt 6 CMake target. Release helpers are `build-macos-release.sh` and `build-ios-release.sh`; `tools/` contains asset-generation scripts. Build output belongs in `build/` and should not be committed.

## Build, Test, and Development Commands

- `./build-macos-release.sh` — cleans and configures a Release Ninja build using Qt 6.12.0, builds the app, and creates the macOS DMG.
- `cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH="$HOME/Qt/6.12.0/macos"` — configures a local Debug build; adjust the Qt path for your installation.
- `cmake --build build --target all` — compiles the application after configuration.
- `cmake --build build --target pack` — packages a Release build with `macdeployqt`.

The checked-in iOS script targets an older qmake-based Qt setup; verify the toolchain before relying on it.

## Coding Style & Naming Conventions

Use C++23 as configured by CMake, 4-space indentation, braces on class and function definitions, and `#pragma once` in headers. Prefer clear `camelCase` for methods and local variables, `PascalCase` for classes, and leading underscores for existing private data members. Keep Qt-facing names and QML properties consistent with the existing `DeviceList` model. Format or review changes manually against nearby code; no formatter or linter is configured.

## Testing Guidelines

No test framework or test suite is currently present. For changes, at minimum compile a Debug build and exercise adding, editing, deleting, and waking a device through the QML UI. Validate MAC-address parsing and socket error paths when changing `src/wol.cpp`.

## Commit & Pull Request Guidelines

Use short, imperative commit subjects consistent with history, such as `Refactor device list handling` or `Update build for Qt 6.12`. Keep commits focused. Pull requests should describe user-visible and platform-specific effects, list verification commands, and include screenshots for QML/UI changes. Call out required Qt versions, packaging changes, or migration steps.

## Security & Configuration Notes

The application sends UDP broadcast packets and stores device entries through `QSettings`. Keep the two intentionally seeded device entries limited to the existing sample devices; do not add additional personal MAC addresses, generated bundles, build output, or machine-specific Qt paths.
