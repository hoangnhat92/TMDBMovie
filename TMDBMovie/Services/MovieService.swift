import Foundation

protocol MovieServiceProtocol {
    func fetchTrending(page: Int) async throws -> PagedResponse<Movie>
    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie>
    func fetchMovieDetail(id: Int) async throws -> Movie
    func fetchMovieImages(id: Int) async throws -> MovieImages
    func fetchMovieReviews(id: Int, page: Int) async throws -> PagedResponse<Review>
    func fetchGenres() async throws -> [Genre]
}

final class MovieService: MovieServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchTrending(page: Int) async throws -> PagedResponse<Movie> {
        try await apiClient.fetch(.trending(page: page))
    }

    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie> {
        try await apiClient.fetch(.search(query: query, page: page))
    }

    func fetchMovieDetail(id: Int) async throws -> Movie {
        try await apiClient.fetch(.movieDetail(id: id))
    }

    func fetchMovieImages(id: Int) async throws -> MovieImages {
        try await apiClient.fetch(.movieImages(id: id))
    }

    func fetchMovieReviews(id: Int, page: Int) async throws -> PagedResponse<Review> {
        try await apiClient.fetch(.movieReviews(id: id, page: page))
    }

    func fetchGenres() async throws -> [Genre] {
        let response: GenreResponse = try await apiClient.fetch(.genres)
        return response.genres
    }
}
