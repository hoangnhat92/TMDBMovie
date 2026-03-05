import Foundation

@Observable
final class FavoritesViewModel {
    private(set) var movies: [Movie] = []

    private let favoriteService: FavoriteServiceProtocol

    init(favoriteService: FavoriteServiceProtocol = FavoriteService()) {
        self.favoriteService = favoriteService
    }

    func loadFavorites() {
        movies = favoriteService.getFavorites()
    }

    func removeFavorite(_ movie: Movie) {
        favoriteService.removeFavorite(movie)
        movies.removeAll { $0.id == movie.id }
    }
}
