import Testing
@testable import TMDBMovie

@Suite("ReviewsViewModel")
@MainActor
struct ReviewsViewModelTests {

    // MARK: - loadReviews

    @Test("success populates reviews")
    func loadReviews_success() async {
        let service = MockMovieService()
        service.movieReviews = [.testReview, .testReview2]
        service.movieReviewsTotalPages = 2
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()

        #expect(vm.reviews.count == 2)
        #expect(!vm.isLoading)
        #expect(vm.error == nil)
        #expect(vm.canLoadMore)
    }

    @Test("failure sets error")
    func loadReviews_failure() async {
        let service = MockMovieService()
        service.shouldThrow = true
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()

        #expect(vm.reviews.isEmpty)
        #expect(vm.error != nil)
        #expect(!vm.isLoading)
    }

    @Test("reloading resets to page 1 and replaces reviews")
    func loadReviews_resetsOnReload() async {
        let service = MockMovieService()
        service.movieReviews = [.testReview]
        service.movieReviewsTotalPages = 1
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()
        #expect(vm.reviews[0].id == "review-1")

        service.movieReviews = [.testReview2]
        await vm.loadReviews()

        #expect(vm.reviews.count == 1)
        #expect(vm.reviews[0].id == "review-2")
    }

    @Test("canLoadMore is false on single page")
    func loadReviews_singlePage_cannotLoadMore() async {
        let service = MockMovieService()
        service.movieReviewsTotalPages = 1
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()

        #expect(!vm.canLoadMore)
    }

    // MARK: - loadMore

    @Test("appends reviews and advances page")
    func loadMore_appendsReviews() async {
        let service = MockMovieService()
        service.movieReviews = [.testReview]
        service.movieReviewsTotalPages = 2
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()
        service.movieReviews = [.testReview2]
        await vm.loadMore()

        #expect(vm.reviews.count == 2)
        #expect(!vm.canLoadMore)
    }

    @Test("is a no-op when canLoadMore is false")
    func loadMore_noOp() async {
        let service = MockMovieService()
        service.movieReviewsTotalPages = 1
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()
        let callsBefore = service.fetchMovieReviewsCallCount
        await vm.loadMore()

        #expect(service.fetchMovieReviewsCallCount == callsBefore)
    }

    @Test("failure during loadMore sets error")
    func loadMore_failure() async {
        let service = MockMovieService()
        service.movieReviews = [.testReview]
        service.movieReviewsTotalPages = 2
        let vm = ReviewsViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadReviews()
        service.shouldThrow = true
        await vm.loadMore()

        #expect(vm.error != nil)
        #expect(vm.reviews.count == 1)
    }

    // MARK: - stored properties

    @Test("movieId and movieTitle are stored correctly")
    func storedProperties() {
        let vm = ReviewsViewModel(movieId: 99, movieTitle: "My Movie", movieService: MockMovieService())

        #expect(vm.movieId == 99)
        #expect(vm.movieTitle == "My Movie")
    }
}
