import Foundation
@testable import TMDBMovie

// MARK: - Mock Movie Service

final class MockMovieService: MovieServiceProtocol {
    var shouldThrow = false
    var error: Error = NSError(
        domain: "TestError", code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Test error"]
    )

    var trendingMovies: [Movie] = []
    var trendingTotalPages = 1
    var searchMoviesResult: [Movie] = []
    var searchMoviesTotalPages = 1
    var movieDetail: Movie = .testData
    var movieImages: MovieImages = .testImages
    var movieReviews: [Review] = []
    var movieReviewsTotalPages = 1

    var fetchTrendingCallCount = 0
    var searchMoviesCallCount = 0
    var fetchMovieDetailCallCount = 0
    var fetchMovieImagesCallCount = 0
    var fetchMovieReviewsCallCount = 0

    func fetchTrending(page: Int) async throws -> PagedResponse<Movie> {
        fetchTrendingCallCount += 1
        if shouldThrow { throw error }
        return PagedResponse(page: page, results: trendingMovies, totalPages: trendingTotalPages, totalResults: trendingMovies.count)
    }

    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie> {
        searchMoviesCallCount += 1
        if shouldThrow { throw error }
        return PagedResponse(page: page, results: searchMoviesResult, totalPages: searchMoviesTotalPages, totalResults: searchMoviesResult.count)
    }

    func fetchMovieDetail(id: Int) async throws -> Movie {
        fetchMovieDetailCallCount += 1
        if shouldThrow { throw error }
        return movieDetail
    }

    func fetchMovieImages(id: Int) async throws -> MovieImages {
        fetchMovieImagesCallCount += 1
        if shouldThrow { throw error }
        return movieImages
    }

    func fetchMovieReviews(id: Int, page: Int) async throws -> PagedResponse<Review> {
        fetchMovieReviewsCallCount += 1
        if shouldThrow { throw error }
        return PagedResponse(page: page, results: movieReviews, totalPages: movieReviewsTotalPages, totalResults: movieReviews.count)
    }

    func fetchGenres() async throws -> [Genre] {
        if shouldThrow { throw error }
        return []
    }
}

// MARK: - Mock Favorite Service

final class MockFavoriteService: FavoriteServiceProtocol {
    var favorites: [Movie] = []

    func getFavorites() -> [Movie] { favorites }

    func addFavorite(_ movie: Movie) {
        guard !favorites.contains(where: { $0.id == movie.id }) else { return }
        favorites.append(movie)
    }

    func removeFavorite(_ movie: Movie) {
        favorites.removeAll { $0.id == movie.id }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }
}

// MARK: - Test Data

extension Movie {
    static let testData = Movie(
        id: 42,
        title: "Test Movie",
        overview: "Test overview",
        posterPath: "/test_poster.jpg",
        backdropPath: "/test_backdrop.jpg",
        releaseDate: "2024-01-15",
        voteAverage: 7.5,
        voteCount: 1000,
        genreIds: [28, 18],
        genres: [Genre(id: 28, name: "Action"), Genre(id: 18, name: "Drama")]
    )

    static let testData2 = Movie(
        id: 43,
        title: "Another Movie",
        overview: "Another overview",
        posterPath: nil,
        backdropPath: nil,
        releaseDate: nil,
        voteAverage: 0.0,
        voteCount: 0,
        genreIds: [],
        genres: []
    )
}

extension MovieImages {
    static let testImages = MovieImages(
        backdrops: [
            MovieImage(filePath: "/backdrop.jpg", width: 1280, height: 720, aspectRatio: 1.78)
        ],
        posters: [
            MovieImage(filePath: "/poster.jpg", width: 500, height: 750, aspectRatio: 0.67)
        ]
    )
}

extension Review {
    static let testReview = Review(
        id: "review-1",
        author: "Test Author",
        content: "Great movie!",
        createdAt: "2024-01-15T10:00:00.000Z",
        authorDetails: AuthorDetails(name: "Test Author", username: "testauthor", avatarPath: nil, rating: 8.0)
    )

    static let testReview2 = Review(
        id: "review-2",
        author: "Another Author",
        content: "Decent film.",
        createdAt: "2024-02-20T14:30:00.000Z",
        authorDetails: nil
    )
}
