import SwiftUI

struct ContentView: View {
    @State private var trendingCoordinator = AppCoordinator()
    @State private var searchCoordinator = AppCoordinator()
    @State private var favoritesCoordinator = AppCoordinator()

    @State private var selectedTab = 0

    @Environment(\.movieService) private var movieService
    @Environment(\.favoriteService) private var favoriteService

    var body: some View {
        TabView(selection: $selectedTab) {
            trendingTab
            searchTab
            favoritesTab
        }
    }

    private var trendingTab: some View {
        NavigationStack(path: $trendingCoordinator.path) {
            TrendingView(
                viewModel: TrendingViewModel(movieService: movieService),
                coordinator: trendingCoordinator
            )
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route, coordinator: trendingCoordinator)
            }
        }
        .tabItem {
            Label("Trending", systemImage: "flame")
        }
        .tag(0)
    }

    private var searchTab: some View {
        NavigationStack(path: $searchCoordinator.path) {
            SearchView(
                viewModel: SearchViewModel(movieService: movieService),
                coordinator: searchCoordinator
            )
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route, coordinator: searchCoordinator)
            }
        }
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
        .tag(1)
    }

    private var favoritesTab: some View {
        NavigationStack(path: $favoritesCoordinator.path) {
            FavoritesView(
                viewModel: FavoritesViewModel(favoriteService: favoriteService),
                coordinator: favoritesCoordinator
            )
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route, coordinator: favoritesCoordinator)
            }
        }
        .tabItem {
            Label("Favorites", systemImage: "heart.fill")
        }
        .tag(2)
    }

    @ViewBuilder
    private func destinationView(for route: Route, coordinator: AppCoordinator) -> some View {
        switch route {
        case .movie(let movieRoute):
            movieDestinationView(for: movieRoute, coordinator: coordinator)
        }
    }

    @ViewBuilder
    private func movieDestinationView(for route: Route.MovieRoute, coordinator: AppCoordinator) -> some View {
        switch route {
        case .detail(let movie):
            MovieDetailView(
                viewModel: MovieDetailViewModel(
                    movie: movie,
                    movieService: movieService,
                    favoriteService: favoriteService
                ),
                coordinator: coordinator
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

#Preview {
    ContentView()
        .environment(\.movieService, MockMovieService())
        .environment(\.favoriteService, MockFavoriteService())
}
