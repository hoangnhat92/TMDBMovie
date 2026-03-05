import SwiftUI

struct ContentView: View {
    @State private var coordinator = AppCoordinator()
    @State private var selectedTab = 0

    private let movieService: MovieServiceProtocol
    private let favoriteService: FavoriteServiceProtocol

    init(
        movieService: MovieServiceProtocol = MovieService(),
        favoriteService: FavoriteServiceProtocol = FavoriteService()
    ) {
        self.movieService = movieService
        self.favoriteService = favoriteService
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            trendingTab
            searchTab
            favoritesTab
        }
    }

    private var trendingTab: some View {
        NavigationStack(path: $coordinator.path) {
            TrendingView(
                viewModel: TrendingViewModel(movieService: movieService),
                coordinator: coordinator
            )
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route)
            }
        }
        .tabItem {
            Label("Trending", systemImage: "flame")
        }
        .tag(0)
    }

    private var searchTab: some View {
        NavigationStack {
            SearchView(
                viewModel: SearchViewModel(movieService: movieService),
                coordinator: coordinator
            )
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route)
            }
        }
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
        .tag(1)
    }

    private var favoritesTab: some View {
        NavigationStack {
            FavoritesView(
                viewModel: FavoritesViewModel(favoriteService: favoriteService),
                coordinator: coordinator
            )
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route)
            }
        }
        .tabItem {
            Label("Favorites", systemImage: "heart.fill")
        }
        .tag(2)
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .movieDetail(let movie):
            MovieDetailView(
                viewModel: MovieDetailViewModel(
                    movie: movie,
                    movieService: movieService,
                    favoriteService: favoriteService
                ),
                coordinator: coordinator
            )
        case .movieImages(let movieId, let movieTitle):
            ImagesView(
                viewModel: ImagesViewModel(
                    movieId: movieId,
                    movieTitle: movieTitle,
                    movieService: movieService
                )
            )
        case .movieReviews(let movieId, let movieTitle):
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
