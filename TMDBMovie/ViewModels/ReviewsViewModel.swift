import Foundation

@Observable
final class ReviewsViewModel {
    private(set) var reviews: [Review] = []
    private(set) var isLoading = false
    private(set) var error: String?
    private var currentPage = 1
    private var totalPages = 1

    let movieId: Int
    let movieTitle: String
    private let movieService: MovieServiceProtocol

    init(
        movieId: Int,
        movieTitle: String,
        movieService: MovieServiceProtocol = MovieService()
    ) {
        self.movieId = movieId
        self.movieTitle = movieTitle
        self.movieService = movieService
    }

    var canLoadMore: Bool {
        currentPage < totalPages && !isLoading
    }

    func loadReviews() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        currentPage = 1

        do {
            let response = try await movieService.fetchMovieReviews(id: movieId, page: 1)
            reviews = response.results
            totalPages = response.totalPages
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func loadMore() async {
        guard canLoadMore else { return }
        isLoading = true
        let nextPage = currentPage + 1

        do {
            let response = try await movieService.fetchMovieReviews(id: movieId, page: nextPage)
            reviews.append(contentsOf: response.results)
            currentPage = nextPage
            totalPages = response.totalPages
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
