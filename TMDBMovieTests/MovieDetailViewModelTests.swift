import Testing
@testable import TMDBMovie

@Suite("MovieDetailViewModel")
@MainActor
struct MovieDetailViewModelTests {

    // MARK: - init

    @Test("isFavorite reflects service state on init")
    func init_isFavorite_whenInService() {
        let favoriteService = MockFavoriteService()
        favoriteService.favorites = [.testData]
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: MockMovieService(),
            favoriteService: favoriteService
        )

        #expect(vm.isFavorite)
    }

    @Test("isFavorite is false when movie is not in service")
    func init_isFavorite_false() {
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: MockMovieService(),
            favoriteService: MockFavoriteService()
        )

        #expect(!vm.isFavorite)
    }

    // MARK: - loadDetail

    @Test("success updates movie, images, and reviews")
    func loadDetail_success() async {
        let movieService = MockMovieService()
        movieService.movieDetail = .testData2
        movieService.movieImages = .testImages
        movieService.movieReviews = [.testReview]
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: movieService,
            favoriteService: MockFavoriteService()
        )

        await vm.loadDetail()

        #expect(vm.movie.id == 43)
        #expect(vm.images?.backdrops.count == 1)
        #expect(vm.images?.posters.count == 1)
        #expect(vm.reviews.count == 1)
        #expect(!vm.isLoading)
        #expect(vm.error == nil)
    }

    @Test("failure sets error and clears isLoading")
    func loadDetail_failure() async {
        let movieService = MockMovieService()
        movieService.shouldThrow = true
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: movieService,
            favoriteService: MockFavoriteService()
        )

        await vm.loadDetail()

        #expect(vm.error != nil)
        #expect(!vm.isLoading)
    }

    // MARK: - toggleFavorite

    @Test("adds movie to favorites when not yet favorited")
    func toggleFavorite_adds() {
        let favoriteService = MockFavoriteService()
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: MockMovieService(),
            favoriteService: favoriteService
        )

        #expect(!vm.isFavorite)
        vm.toggleFavorite()

        #expect(vm.isFavorite)
        #expect(favoriteService.isFavorite(.testData))
    }

    @Test("removes movie from favorites when already favorited")
    func toggleFavorite_removes() {
        let favoriteService = MockFavoriteService()
        favoriteService.favorites = [.testData]
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: MockMovieService(),
            favoriteService: favoriteService
        )

        #expect(vm.isFavorite)
        vm.toggleFavorite()

        #expect(!vm.isFavorite)
        #expect(!favoriteService.isFavorite(.testData))
    }

    @Test("double toggle returns to original state")
    func toggleFavorite_doubleToggle() {
        let favoriteService = MockFavoriteService()
        let vm = MovieDetailViewModel(
            movie: .testData,
            movieService: MockMovieService(),
            favoriteService: favoriteService
        )

        vm.toggleFavorite()
        vm.toggleFavorite()

        #expect(!vm.isFavorite)
        #expect(!favoriteService.isFavorite(.testData))
    }
}
