import Testing
@testable import TMDBMovie

@Suite("ImagesViewModel")
@MainActor
struct ImagesViewModelTests {

    @Test("success populates backdrops and posters")
    func loadImages_success() async {
        let service = MockMovieService()
        service.movieImages = MovieImages(
            backdrops: [
                MovieImage(filePath: "/bd1.jpg", width: 1280, height: 720, aspectRatio: 1.78),
                MovieImage(filePath: "/bd2.jpg", width: 1280, height: 720, aspectRatio: 1.78)
            ],
            posters: [
                MovieImage(filePath: "/p1.jpg", width: 500, height: 750, aspectRatio: 0.67)
            ]
        )
        let vm = ImagesViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadImages()

        #expect(vm.backdrops.count == 2)
        #expect(vm.posters.count == 1)
        #expect(!vm.isLoading)
        #expect(vm.error == nil)
    }

    @Test("failure sets error and leaves collections empty")
    func loadImages_failure() async {
        let service = MockMovieService()
        service.shouldThrow = true
        let vm = ImagesViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadImages()

        #expect(vm.backdrops.isEmpty)
        #expect(vm.posters.isEmpty)
        #expect(vm.error != nil)
        #expect(!vm.isLoading)
    }

    @Test("calling loadImages a second time reloads data")
    func loadImages_reload() async {
        let service = MockMovieService()
        service.movieImages = .testImages
        let vm = ImagesViewModel(movieId: 42, movieTitle: "Test Movie", movieService: service)

        await vm.loadImages()
        let firstCallCount = service.fetchMovieImagesCallCount

        service.movieImages = MovieImages(backdrops: [], posters: [])
        await vm.loadImages()

        #expect(service.fetchMovieImagesCallCount == firstCallCount + 1)
        #expect(vm.backdrops.isEmpty)
    }

    @Test("movieId and movieTitle are stored correctly")
    func storedProperties() {
        let vm = ImagesViewModel(movieId: 77, movieTitle: "Image Movie", movieService: MockMovieService())

        #expect(vm.movieId == 77)
        #expect(vm.movieTitle == "Image Movie")
    }
}
