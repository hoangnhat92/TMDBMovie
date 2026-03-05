import Testing
@testable import TMDBMovie

@Suite("TrendingViewModel")
@MainActor
struct TrendingViewModelTests {

    // MARK: - loadTrending

    @Test("success populates movies and clears error")
    func loadTrending_success() async {
        let service = MockMovieService()
        service.trendingMovies = [.testData, .testData2]
        service.trendingTotalPages = 3
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()

        #expect(vm.movies.count == 2)
        #expect(vm.movies[0].id == 42)
        #expect(vm.movies[1].id == 43)
        #expect(!vm.isLoading)
        #expect(vm.error == nil)
        #expect(vm.canLoadMore)
    }

    @Test("failure sets error message and leaves movies empty")
    func loadTrending_failure() async {
        let service = MockMovieService()
        service.shouldThrow = true
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()

        #expect(vm.movies.isEmpty)
        #expect(vm.error != nil)
        #expect(!vm.isLoading)
    }

    @Test("reloading resets to page 1 and replaces movies")
    func loadTrending_replacesPreviousMovies() async {
        let service = MockMovieService()
        service.trendingMovies = [.testData]
        service.trendingTotalPages = 1
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()
        #expect(vm.movies[0].id == 42)

        service.trendingMovies = [.testData2]
        await vm.loadTrending()

        #expect(vm.movies.count == 1)
        #expect(vm.movies[0].id == 43)
    }

    @Test("single page sets canLoadMore to false")
    func loadTrending_singlePage_cannotLoadMore() async {
        let service = MockMovieService()
        service.trendingMovies = [.testData]
        service.trendingTotalPages = 1
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()

        #expect(!vm.canLoadMore)
    }

    // MARK: - loadMore

    @Test("appends movies and advances page")
    func loadMore_appendsMovies() async {
        let service = MockMovieService()
        service.trendingMovies = [.testData]
        service.trendingTotalPages = 2
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()
        #expect(vm.canLoadMore)

        service.trendingMovies = [.testData2]
        await vm.loadMore()

        #expect(vm.movies.count == 2)
        #expect(vm.movies[1].id == 43)
        #expect(!vm.canLoadMore)
    }

    @Test("is a no-op when canLoadMore is false")
    func loadMore_noOp_whenCannotLoadMore() async {
        let service = MockMovieService()
        service.trendingMovies = [.testData]
        service.trendingTotalPages = 1
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()

        let callsBefore = service.fetchTrendingCallCount
        await vm.loadMore()

        #expect(service.fetchTrendingCallCount == callsBefore)
    }

    @Test("failure during loadMore sets error")
    func loadMore_failure() async {
        let service = MockMovieService()
        service.trendingMovies = [.testData]
        service.trendingTotalPages = 2
        let vm = TrendingViewModel(movieService: service)

        await vm.loadTrending()
        service.shouldThrow = true
        await vm.loadMore()

        #expect(vm.error != nil)
        #expect(vm.movies.count == 1) // original results remain
    }
}
