import Foundation

@Observable
final class TrendingViewModel {
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var error: String?
    private var currentPage = 1
    private var totalPages = 1

    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }

    var canLoadMore: Bool {
        currentPage < totalPages && !isLoading
    }

    func loadTrending() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        currentPage = 1

        do {
            let response = try await movieService.fetchTrending(page: 1)
            movies = response.results
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
            let response = try await movieService.fetchTrending(page: nextPage)
            movies.append(contentsOf: response.results)
            currentPage = nextPage
            totalPages = response.totalPages
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
