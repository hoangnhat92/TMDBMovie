# TMDBMovie

An iOS app for browsing movies using the [TMDb API](https://www.themoviedb.org/documentation/api).

**Platform:** iOS 17.6+  
**Language:** Swift 6.0 
**UI:** SwiftUI

---

## Architecture

The app is built around three complementary patterns: **MVVM** for screen logic, the **Coordinator** pattern for navigation, and **Protocol + Environment injection** for dependencies.

### Layer Overview

```
┌─────────────────────────────────────────────┐
│                   Views                     │  SwiftUI views, purely declarative
│  TrendingView / SearchView / FavoritesView  │
│  MovieDetailView / ReviewsView / ImagesView │
└─────────────┬───────────────────────────────┘
              │ owns (via @State)
┌─────────────▼───────────────────────────────┐
│                 ViewModels                  │  @Observable, business/UI logic
│  TrendingViewModel / SearchViewModel / ...  │
└─────────────┬───────────────────────────────┘
              │ depends on (protocol)
┌─────────────▼───────────────────────────────┐
│                  Services                   │  Domain layer
│   MovieService · FavoriteService            │
└─────────────┬───────────────────────────────┘
              │ depends on (protocol)
┌─────────────▼───────────────────────────────┐
│               Networking                    │  Transport layer
│   APIClient · APIEndpoint                   │
└─────────────────────────────────────────────┘
```

---

### MVVM with `@Observable`

ViewModels use Swift 5.9's `@Observable` macro instead of `ObservableObject`. Views hold their ViewModel as `@State`, which gives the ViewModel a lifetime tied to the view and avoids the overhead of `@StateObject`.

```swift
// ViewModel
@Observable
final class TrendingViewModel {
    private(set) var movies: [Movie] = []
    private let movieService: any MovieServiceProtocol
    ...
}

// View
struct TrendingView: View {
    @State var viewModel: TrendingViewModel
    ...
}
```

---

### Coordinator Pattern

Navigation is handled by `AppCoordinator`, a type-safe wrapper around SwiftUI's `NavigationPath`. Each tab owns its own coordinator instance, so tabs have fully independent navigation stacks.

```
ContentView (TabView)
  ├── NavigationStack ── trendingCoordinator
  ├── NavigationStack ── searchCoordinator
  └── NavigationStack ── favoritesCoordinator
```

Routes are modelled as a typed enum, making all valid destinations explicit and exhaustively checked at compile time:

```swift
enum Route: Hashable {
    case movie(MovieRoute)

    enum MovieRoute: Hashable {
        case detail(Movie)
        case images(movieId: Int, movieTitle: String)
        case reviews(movieId: Int, movieTitle: String)
    }
}
```

`ContentView` owns `.navigationDestination(for: Route.self)` for each stack and resolves destinations into concrete views. Coordinators are passed to views only where push/pop is needed; leaf views like `ReviewsView` and `ImagesView` receive no coordinator.

---

### Protocol + Environment Dependency Injection

All cross-layer dependencies are expressed as protocols. Concrete implementations are injected via SwiftUI's `Environment` using the `@Entry` macro, keeping Views and ViewModels free of concrete imports.

**Protocols**

| Protocol | Responsibility |
|---|---|
| `MovieServiceProtocol` | Fetching trending movies, search, detail, images, reviews, genres |
| `FavoriteServiceProtocol` | Reading and mutating the local favorites list |
| `APIClientProtocol` | Generic HTTP fetch over `URLSession` |

**Environment keys** (defined with `@Entry`):

```swift
extension EnvironmentValues {
    @Entry var movieService: any MovieServiceProtocol = UnimplementedMovieService()
    @Entry var favoriteService: any FavoriteServiceProtocol = UnimplementedFavoriteService()
}
```

The defaults are **unimplemented stubs** — they `fatalError` immediately if called. This makes a missing injection a loud crash rather than silent wrong behavior.

**Real implementations are injected once at the app root:**

```swift
// TMDBMovieApp.swift
ContentView()
    .environment(\.movieService, MovieService())
    .environment(\.favoriteService, FavoriteService())
```

**Views read from the environment and forward to their ViewModel:**

```swift
struct ContentView: View {
    @Environment(\.movieService) private var movieService
    @Environment(\.favoriteService) private var favoriteService

    // ViewModels are constructed here with the environment-provided service
}
```

ViewModel initialisers accept no default service — they require an explicit argument, enforcing that the caller always decides which concrete type to use:

```swift
init(movieService: any MovieServiceProtocol) { ... }  // no default
```

**For Previews and tests**, swap implementations via the same environment modifier:

```swift
#Preview {
    TrendingView(viewModel: TrendingViewModel(movieService: MockMovieService()), ...)
        .environment(\.movieService, MockMovieService())
}
```

---

### Networking Layer

```
APIEndpoint (enum, nonisolated, Sendable)
    │  builds URL
    ▼
APIClient : APIClientProtocol
    │  URLSession.data(from:)  →  JSONDecoder
    ▼
MovieService : MovieServiceProtocol
    │  maps raw responses to domain types
    ▼
ViewModel
```

`APIEndpoint` is a `nonisolated` `Sendable` enum so it can be constructed and passed across actors without warnings under Swift 6's strict concurrency.

---

### Swift 6 Concurrency

The project runs with `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, meaning all types are `@MainActor`-isolated by default. Key consequences:

- **Model structs** (`Movie`, `Genre`, `Review`, etc.) are `nonisolated` to opt out of `@MainActor`, which is required for JSON decoding to work off the main thread (`Codable` synthesis becomes `@MainActor` otherwise).
- **`APIEndpoint`** is `nonisolated` and `Sendable` for the same reason.
- ViewModels are effectively `@MainActor` by default, matching SwiftUI's update model.

---

## Project Structure

```
TMDBMovie/
├── TMDBMovieApp.swift              # App entry point, environment injection
├── ContentView.swift               # TabView + navigation destination resolution
├── Environment+Services.swift      # @Entry environment keys
│
├── Models/
│   ├── Movie.swift
│   ├── Genre.swift
│   ├── Review.swift
│   ├── APIResponses.swift          # PagedResponse, MovieImages, MovieImage
│   └── Movie+SampleData.swift
│
├── Networking/
│   ├── APIClient.swift             # URLSession wrapper
│   ├── APIEndpoint.swift           # Typed URL builder
│   └── Bundle+APIKey.swift
│
├── Services/
│   ├── MovieService.swift          # MovieServiceProtocol + MovieService
│   ├── FavoriteService.swift       # FavoriteServiceProtocol + FavoriteService
│   └── UnimplementedServices.swift # Crash-on-call stubs (env defaults)
│
├── ViewModels/
│   ├── TrendingViewModel.swift
│   ├── SearchViewModel.swift
│   ├── FavoritesViewModel.swift
│   ├── MovieDetailViewModel.swift
│   ├── ReviewsViewModel.swift
│   └── ImagesViewModel.swift
│
├── Views/
│   ├── TrendingView.swift
│   ├── SearchView.swift
│   ├── FavoritesView.swift
│   ├── MovieDetailView.swift
│   ├── ReviewsView.swift
│   ├── ImagesView.swift
│   └── Components/
│       ├── MovieCardView.swift
│       ├── MoviePosterCard.swift
│       ├── CachedAsyncImage.swift
│       └── ReviewCard.swift
│
├── Navigation/
│   └── AppCoordinator.swift        # Route enum + NavigationPath wrapper
│
└── Preview Content/
    └── MockServices.swift          # MockMovieService, MockFavoriteService
```

---

## Setup

1. Get a free API key from [themoviedb.org](https://www.themoviedb.org/settings/api).
2. Add a `Config.xcconfig` file (or `Info.plist` entry) with:
   ```
   TMDB_API_KEY = your_key_here
   ```
3. Build and run in Xcode 15+.
