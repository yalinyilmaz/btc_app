# BtcTurk Market

A responsive Flutter market application built for the BtcTurk Flutter Developer Code Case. It displays market pairs, keeps favorites locally, streams live ticker updates, and visualizes historical closing prices.

## Features

- Market pairs loaded from the public BtcTurk ticker API
- Repository-level caching for the complete ticker snapshot
- Real-time prices over the BtcTurk WebSocket feed
- Persistent favorites with `HydratedCubit`
- Seven-day hourly closing-price chart with touch/drag inspection
- Turkish and English localization
- Adaptive mobile, tablet, and desktop/web layouts
- Typed loading, empty, retry, connection, and server-error states

## Architecture

The project follows an `app / core / feature` structure inspired by feature-first clean architecture:

```text
lib/
├── app/
│   ├── components/       # Shared application widgets
│   ├── localization/     # Locale configuration and generated keys
│   ├── routes/           # GoRouter configuration and route-level DI
│   └── theme/            # Theme, colors, and typography
├── core/
│   ├── constants/        # API and shared constants
│   ├── extensions/       # Context and number-formatting extensions
│   ├── network/          # Shared Dio factory
│   └── responsive/       # Breakpoints and layout definitions
└── feature/
    └── market/
        ├── cubit/        # Pair list, chart, and favorite state
        ├── models/       # API DTOs and domain models
        ├── repo/         # BtcTurk repository and typed failures
        ├── services/     # Retrofit and WebSocket data sources
        └── views/        # Pages and focused UI components
```

Dependencies are created at the application boundary and injected through `RepositoryProvider` and route-level `BlocProvider` instances. Cubits receive the app-scoped `BtcTurkMarketRepository` through their constructors, while views remain unaware of Dio, Retrofit, and socket setup details. A future market source can be registered under its own concrete repository type and injected explicitly into the Cubit that needs it.

## Technical decisions

### Cubit and targeted rebuilds

Each screen owns a focused Cubit and immutable Equatable state. `BlocSelector` is used where a widget needs only a small state slice, such as connection status, favorites, the pair list, or chart status. Transient chart-point selection remains local widget state because it has no application-level lifecycle.

### Favorites persistence

Favorites are a small, non-sensitive set of symbols, so `HydratedCubit` keeps the state and persistence lifecycle together. Only a versioned, sorted symbol list is serialized. Hydrated storage is not treated as a general database; a future feature requiring queries, relationships, or larger offline datasets should move behind a dedicated local repository.

### REST and WebSocket separation

Ticker and chart calls use separate Retrofit services because BtcTurk exposes them from different hosts. Live ticker transport is isolated behind `MarketSocketService`, allowing another transport or test implementation without changing the Cubit or UI.

### Ticker snapshot cache

The public ticker endpoint returns one complete snapshot and does not expose server-side page parameters. The repository fetches and sorts the response once, stores it as an immutable in-memory snapshot, and reuses it for subsequent reads. Explicit refreshes replace the cache with a fresh API response.

`PairListCubit` receives the complete collection. The mobile list and tablet/desktop grid use builder constructors, so Flutter creates cards lazily as they enter the viewport even though the network snapshot is loaded at once.

### Responsive behavior

- Mobile: single-column pair list and stacked chart details
- Tablet: responsive pair grid and stacked chart details
- Desktop/web: wider pair grid and side-by-side chart/details layout

Layout selection uses centralized breakpoints at 600 and 1024 logical pixels. Shared page content is capped at 1200 pixels.

### Native branding

Android and iOS launcher icons and native splash screens are generated from the master PNG files in `assets/branding`. The splash uses a transparent, centered wordmark over the app's `#09101B` background. Android 12 has a separately padded 1152×1152 source so the complete wordmark remains inside the platform's circular safe area. The iOS icon master is opaque, while Android also receives adaptive foreground and background layers.

## API endpoints

- Ticker: `https://api.btcturk.com/api/v2/ticker`
- Kline history: `https://graph-api.btcturk.com/v1/klines/history`
- WebSocket: `wss://ws-feed-pro.btcturk.com/`

The ticker response envelope includes `data`, `success`, `message`, and `code`. The Kline adapter converts the parallel TradingView-style `t/o/h/l/c/v` arrays into safe, chronological `KlineCandle` domain objects.

## Getting started

Requirements:

- Flutter `>=3.44.0`
- Dart `>=3.12.0`

Install dependencies and generate Retrofit/JSON sources:

```bash
flutter pub get
dart run build_runner build
```

Regenerate native app icons and splash assets after changing a branding master:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Regenerate localization keys after editing translation files:

```bash
dart run easy_localization:generate \
  -S assets/translations \
  -f keys \
  -O lib/app/localization \
  -o locale_keys.g.dart
```

Run on a connected target:

```bash
flutter run
```

Examples:

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

## Quality checks

```bash
flutter analyze
flutter test
flutter build web --release
```

Tests cover response parsing, repository error mapping and caching, WebSocket parsing, Cubit state transitions, favorites serialization, lazy list rendering, responsive chart rendering, and chart touch interaction.

## Web limitation

The responsive web application builds successfully, but direct browser requests to the public BtcTurk REST hosts can be blocked by their CORS policy. Android and iOS are not affected. A deployed web version should route REST calls through an approved same-origin backend proxy or gateway; the existing service/repository boundary supports that change without modifying UI code.

## Possible next steps

- Firebase Crashlytics integration after Firebase environments are configured
- Same-origin API gateway for production web support
- Additional golden and end-to-end tests
- CI workflow for analyze, test, and release builds
