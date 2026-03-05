import Testing
@testable import TMDBMovie

@Suite("FavoritesViewModel")
@MainActor
struct FavoritesViewModelTests {

    @Test("loadFavorites populates movies from service")
    func loadFavorites_populatesMovies() {
        let service = MockFavoriteService()
        service.favorites = [.testData, .testData2]
        let vm = FavoritesViewModel(favoriteService: service)

        vm.loadFavorites()

        #expect(vm.movies.count == 2)
        #expect(vm.movies[0].id == 42)
        #expect(vm.movies[1].id == 43)
    }

    @Test("loadFavorites with empty service returns empty list")
    func loadFavorites_empty() {
        let vm = FavoritesViewModel(favoriteService: MockFavoriteService())

        vm.loadFavorites()

        #expect(vm.movies.isEmpty)
    }

    @Test("removeFavorite removes correct movie from list and service")
    func removeFavorite_removesMovie() {
        let service = MockFavoriteService()
        service.favorites = [.testData, .testData2]
        let vm = FavoritesViewModel(favoriteService: service)
        vm.loadFavorites()

        vm.removeFavorite(.testData)

        #expect(vm.movies.count == 1)
        #expect(vm.movies[0].id == 43)
        #expect(!service.isFavorite(.testData))
    }

    @Test("removeFavorite with non-existent movie is a no-op")
    func removeFavorite_nonExistent() {
        let service = MockFavoriteService()
        service.favorites = [.testData]
        let vm = FavoritesViewModel(favoriteService: service)
        vm.loadFavorites()

        vm.removeFavorite(.testData2)

        #expect(vm.movies.count == 1)
    }
}
