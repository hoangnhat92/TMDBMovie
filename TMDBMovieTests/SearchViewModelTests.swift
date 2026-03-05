import Testing
@testable import TMDBMovie

@Suite("SearchViewModel")
@MainActor
struct SearchViewModelTests {

    // MARK: - search

    @Test("empty query clears movies without calling service")
    func search_emptyQuery_clearsMovies() {
        let service = MockMovieService()
        let vm = SearchViewModel(movieService: service)
        vm.query = "   "

        vm.search()

        #expect(vm.movies.isEmpty)
        #expect(service.searchMoviesCallCount == 0)
    }

    @Test("valid query loads movies after debounce")
    func search_validQuery_loadsMovies() async throws {
        let service = MockMovieService()
        service.searchMoviesResult = [.testData, .testData2]
        let vm = SearchViewModel(movieService: service)

        vm.query = "Batman"
        vm.search()
        try await Task.sleep(for: .milliseconds(400))

        #expect(vm.movies.count == 2)
        #expect(!vm.isLoading)
        #expect(vm.error == nil)
    }

    @Test("failure sets error after debounce")
    func search_failure() async throws {
        let service = MockMovieService()
        service.shouldThrow = true
        let vm = SearchViewModel(movieService: service)

        vm.query = "Batman"
        vm.search()
        try await Task.sleep(for: .milliseconds(400))

        #expect(vm.movies.isEmpty)
        #expect(vm.error != nil)
        #expect(!vm.isLoading)
    }

    @Test("subsequent search cancels previous in-flight task")
    func search_cancellation() async throws {
        let service = MockMovieService()
        service.searchMoviesResult = [.testData]
        let vm = SearchViewModel(movieService: service)

        vm.query = "first"
        vm.search()

        // Immediately replace with second query (cancels first)
        vm.query = "second"
        vm.search()
        try await Task.sleep(for: .milliseconds(500))

        // Only one network call should have been made
        #expect(service.searchMoviesCallCount == 1)
    }

    @Test("setting empty query after results clears movies")
    func search_clearAfterResults() async throws {
        let service = MockMovieService()
        service.searchMoviesResult = [.testData]
        let vm = SearchViewModel(movieService: service)

        vm.query = "Batman"
        vm.search()
        try await Task.sleep(for: .milliseconds(400))
        #expect(vm.movies.count == 1)

        vm.query = ""
        vm.search()
        #expect(vm.movies.isEmpty)
    }

    // MARK: - loadMore

    @Test("appends results and advances page")
    func loadMore_appendsResults() async throws {
        let service = MockMovieService()
        service.searchMoviesResult = [.testData]
        service.searchMoviesTotalPages = 2
        let vm = SearchViewModel(movieService: service)

        vm.query = "Batman"
        vm.search()
        try await Task.sleep(for: .milliseconds(400))
        #expect(vm.canLoadMore)

        service.searchMoviesResult = [.testData2]
        await vm.loadMore()

        #expect(vm.movies.count == 2)
        #expect(!vm.canLoadMore)
    }

    @Test("is a no-op when query is empty")
    func loadMore_emptyQuery_noOp() async {
        let service = MockMovieService()
        let vm = SearchViewModel(movieService: service)

        await vm.loadMore()

        #expect(service.searchMoviesCallCount == 0)
    }

    @Test("failure during loadMore sets error")
    func loadMore_failure() async throws {
        let service = MockMovieService()
        service.searchMoviesResult = [.testData]
        service.searchMoviesTotalPages = 2
        let vm = SearchViewModel(movieService: service)

        vm.query = "Batman"
        vm.search()
        try await Task.sleep(for: .milliseconds(400))

        service.shouldThrow = true
        await vm.loadMore()

        #expect(vm.error != nil)
        #expect(vm.movies.count == 1) // original results remain
    }
}
