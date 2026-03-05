#if DEBUG
import Foundation

final class MockMovieService: MovieServiceProtocol {
    var trendingMovies: [Movie] = Movie.sampleList
    var searchResults: [Movie] = Movie.sampleList
    var movieDetail: Movie = .sampleData
    var movieImages: MovieImages = MovieImages(
        backdrops: [
            MovieImage(filePath: "/hYgUkH7TusddHRtelj53I6gFOWR.jpg", width: 1280, height: 720, aspectRatio: 1.78)
        ],
        posters: [
            MovieImage(filePath: "/sojEzvfxR2DBcDSJyAisX8TWjov.jpg", width: 500, height: 750, aspectRatio: 0.67)
        ]
    )
    var movieReviews: [Review] = [.sampleData]

    func fetchTrending(page: Int) async throws -> PagedResponse<Movie> {
        PagedResponse(page: 1, results: trendingMovies, totalPages: 1, totalResults: trendingMovies.count)
    }

    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie> {
        PagedResponse(page: 1, results: searchResults, totalPages: 1, totalResults: searchResults.count)
    }

    func fetchMovieDetail(id: Int) async throws -> Movie {
        movieDetail
    }

    func fetchMovieImages(id: Int) async throws -> MovieImages {
        movieImages
    }

    func fetchMovieReviews(id: Int, page: Int) async throws -> PagedResponse<Review> {
        PagedResponse(page: 1, results: movieReviews, totalPages: 1, totalResults: movieReviews.count)
    }

    func fetchGenres() async throws -> [Genre] {
        [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Drama")]
    }
}

final class MockFavoriteService: FavoriteServiceProtocol {
    var favorites: [Movie] = [.sampleData]

    func getFavorites() -> [Movie] {
        favorites
    }

    func addFavorite(_ movie: Movie) {
        favorites.append(movie)
    }

    func removeFavorite(_ movie: Movie) {
        favorites.removeAll { $0.id == movie.id }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }
}
#endif
