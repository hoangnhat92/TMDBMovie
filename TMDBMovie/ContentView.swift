import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State private var coordinator = AppCoordinator()

    @Environment(\.movieService) private var movieService
    @Environment(\.favoriteService) private var favoriteService

    var body: some View {
        @Bindable var coordinator = coordinator
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.trendingPath) {
                TrendingView(viewModel: TrendingViewModel(movieService: movieService))
                    .withAppDestinations()
            }
            .tabItem { Label("Trending", systemImage: "flame") }
            .tag(Tab.trending)

            NavigationStack(path: $coordinator.searchPath) {
                SearchView(viewModel: SearchViewModel(movieService: movieService))
                    .withAppDestinations()
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(Tab.search)

            NavigationStack(path: $coordinator.favoritesPath) {
                FavoritesView(viewModel: FavoritesViewModel(favoriteService: favoriteService))
                    .withAppDestinations()
            }
            .tabItem { Label("Favorites", systemImage: "heart.fill") }
            .tag(Tab.favorites)
        }
        .sheet(item: $coordinator.sheet) { route in
            sheetView(for: route)
        }
        .environment(coordinator)
    }

    @ViewBuilder
    private func sheetView(for route: SheetRoute) -> some View {
        switch route {
        case .movieDetail(let movie):
            NavigationStack {
                MovieDetailView(
                    viewModel: MovieDetailViewModel(
                        movie: movie,
                        movieService: movieService,
                        favoriteService: favoriteService
                    )
                )
            }
            .environment(coordinator)
        }
    }
}

// MARK: - Navigation Destinations

private struct NavigationDestinationsModifier: ViewModifier {
    @Environment(\.movieService) private var movieService
    @Environment(\.favoriteService) private var favoriteService

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route)
            }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .movie(let movieRoute):
            switch movieRoute {
            case .detail(let movie):
                MovieDetailView(
                    viewModel: MovieDetailViewModel(
                        movie: movie,
                        movieService: movieService,
                        favoriteService: favoriteService
                    )
                )
            case .images(let movieId, let movieTitle):
                ImagesView(
                    viewModel: ImagesViewModel(
                        movieId: movieId,
                        movieTitle: movieTitle,
                        movieService: movieService
                    )
                )
            case .reviews(let movieId, let movieTitle):
                ReviewsView(
                    viewModel: ReviewsViewModel(
                        movieId: movieId,
                        movieTitle: movieTitle,
                        movieService: movieService
                    )
                )
            }
        }
    }
}

private extension View {
    func withAppDestinations() -> some View {
        modifier(NavigationDestinationsModifier())
    }
}

#Preview {
    ContentView()
        .environment(\.movieService, MockMovieService())
        .environment(\.favoriteService, MockFavoriteService())
}
