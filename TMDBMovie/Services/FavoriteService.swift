import Foundation

protocol FavoriteServiceProtocol {
    func getFavorites() -> [Movie]
    func addFavorite(_ movie: Movie)
    func removeFavorite(_ movie: Movie)
    func isFavorite(_ movie: Movie) -> Bool
}

final class FavoriteService: FavoriteServiceProtocol {
    private let defaults: UserDefaults
    private let key = "favorite_movies"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getFavorites() -> [Movie] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Movie].self, from: data)) ?? []
    }

    func addFavorite(_ movie: Movie) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.id == movie.id }) else { return }
        favorites.append(movie)
        save(favorites)
    }

    func removeFavorite(_ movie: Movie) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == movie.id }
        save(favorites)
    }

    func isFavorite(_ movie: Movie) -> Bool {
        getFavorites().contains { $0.id == movie.id }
    }

    private func save(_ movies: [Movie]) {
        let data = try? JSONEncoder().encode(movies)
        defaults.set(data, forKey: key)
    }
}
