import Foundation

@Observable
final class SearchViewModel {
    var query = ""
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var error: String?
    private var currentPage = 1
    private var totalPages = 1
    private var currentTask: Task<Void, Never>?

    private let movieService: any MovieServiceProtocol

    init(movieService: any MovieServiceProtocol) {
        self.movieService = movieService
    }

    var canLoadMore: Bool {
        currentPage < totalPages && !isLoading
    }

    func search() {
        currentTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            movies = []
            return
        }

        currentTask = Task { @MainActor [weak self] in
            guard let self else { return }
            // debounce
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }

            isLoading = true
            error = nil
            currentPage = 1

            do {
                let response = try await movieService.searchMovies(query: trimmed, page: 1)
                guard !Task.isCancelled else { return }
                movies = response.results
                totalPages = response.totalPages
            } catch {
                guard !Task.isCancelled else { return }
                self.error = error.localizedDescription
            }

            isLoading = false
        }
    }

    func loadMore() async {
        guard canLoadMore else { return }
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        let nextPage = currentPage + 1

        do {
            let response = try await movieService.searchMovies(query: trimmed, page: nextPage)
            movies.append(contentsOf: response.results)
            currentPage = nextPage
            totalPages = response.totalPages
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
