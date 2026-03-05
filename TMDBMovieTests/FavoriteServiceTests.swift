import Foundation
import Testing
@testable import TMDBMovie

@Suite("FavoriteService")
@MainActor
struct FavoriteServiceTests {

    private func makeSUT() -> FavoriteService {
        let suiteName = "test.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        return FavoriteService(defaults: defaults)
    }

    @Test("getFavorites returns empty list initially")
    func getFavorites_empty() {
        let service = makeSUT()

        #expect(service.getFavorites().isEmpty)
    }

    @Test("addFavorite persists movie")
    func addFavorite_persistsMovie() {
        let service = makeSUT()

        service.addFavorite(.testData)

        let favorites = service.getFavorites()
        #expect(favorites.count == 1)
        #expect(favorites[0].id == 42)
        #expect(favorites[0].title == "Test Movie")
    }

    @Test("addFavorite is idempotent - does not create duplicates")
    func addFavorite_noDuplicate() {
        let service = makeSUT()

        service.addFavorite(.testData)
        service.addFavorite(.testData)

        #expect(service.getFavorites().count == 1)
    }

    @Test("addFavorite can store multiple distinct movies")
    func addFavorite_multipleMovies() {
        let service = makeSUT()

        service.addFavorite(.testData)
        service.addFavorite(.testData2)

        #expect(service.getFavorites().count == 2)
    }

    @Test("removeFavorite deletes the correct movie")
    func removeFavorite_removesCorrectMovie() {
        let service = makeSUT()
        service.addFavorite(.testData)
        service.addFavorite(.testData2)

        service.removeFavorite(.testData)

        let favorites = service.getFavorites()
        #expect(favorites.count == 1)
        #expect(favorites[0].id == 43)
    }

    @Test("removeFavorite on non-existent movie is a no-op")
    func removeFavorite_nonExistent() {
        let service = makeSUT()
        service.addFavorite(.testData)

        service.removeFavorite(.testData2)

        #expect(service.getFavorites().count == 1)
    }

    @Test("isFavorite returns true for a saved movie")
    func isFavorite_true() {
        let service = makeSUT()
        service.addFavorite(.testData)

        #expect(service.isFavorite(.testData))
    }

    @Test("isFavorite returns false for an unsaved movie")
    func isFavorite_false() {
        let service = makeSUT()

        #expect(!service.isFavorite(.testData))
    }

    @Test("isFavorite returns false after removal")
    func isFavorite_afterRemoval() {
        let service = makeSUT()
        service.addFavorite(.testData)
        service.removeFavorite(.testData)

        #expect(!service.isFavorite(.testData))
    }

    @Test("favorites persist across service instances sharing the same UserDefaults")
    func persistence_acrossInstances() {
        let suiteName = "test.persistence.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        let service1 = FavoriteService(defaults: defaults)

        service1.addFavorite(.testData)

        let service2 = FavoriteService(defaults: defaults)
        #expect(service2.getFavorites().count == 1)
        #expect(service2.isFavorite(.testData))
    }
}
