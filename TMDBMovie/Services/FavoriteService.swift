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
    private lazy var cachedFavorites: [Movie] = loadFromDisk()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getFavorites() -> [Movie] {
        cachedFavorites
    }

    func addFavorite(_ movie: Movie) {
        guard !cachedFavorites.contains(where: { $0.id == movie.id }) else { return }
        cachedFavorites.append(movie)
        persist()
    }

    func removeFavorite(_ movie: Movie) {
        cachedFavorites.removeAll { $0.id == movie.id }
        persist()
    }

    func isFavorite(_ movie: Movie) -> Bool {
        cachedFavorites.contains { $0.id == movie.id }
    }

    private func loadFromDisk() -> [Movie] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Movie].self, from: data)) ?? []
    }

    private func persist() {
        let data = try? JSONEncoder().encode(cachedFavorites)
        defaults.set(data, forKey: key)
    }
}

struct UnimplementedFavoriteService: FavoriteServiceProtocol {
    func getFavorites() -> [Movie] {
        fatalError("FavoriteServiceProtocol.getFavorites not implemented — inject a real FavoriteService via environment")
    }

    func addFavorite(_ movie: Movie) {
        fatalError("FavoriteServiceProtocol.addFavorite not implemented — inject a real FavoriteService via environment")
    }

    func removeFavorite(_ movie: Movie) {
        fatalError("FavoriteServiceProtocol.removeFavorite not implemented — inject a real FavoriteService via environment")
    }

    func isFavorite(_ movie: Movie) -> Bool {
        fatalError("FavoriteServiceProtocol.isFavorite not implemented — inject a real FavoriteService via environment")
    }
}
