import Testing
@testable import TMDBMovie

@Suite("AppCoordinator")
@MainActor
struct AppCoordinatorTests {

    @Test("path is empty on init")
    func init_pathIsEmpty() {
        let coordinator = AppCoordinator()

        #expect(coordinator.path.isEmpty)
    }

    @Test("push adds a route to the path")
    func push_addsRoute() {
        let coordinator = AppCoordinator()

        coordinator.push(.movie(.detail(.testData)))

        #expect(!coordinator.path.isEmpty)
        #expect(coordinator.path.count == 1)
    }

    @Test("push multiple routes increments count")
    func push_multipleRoutes() {
        let coordinator = AppCoordinator()

        coordinator.push(.movie(.detail(.testData)))
        coordinator.push(.movie(.images(movieId: 1, movieTitle: "Test")))

        #expect(coordinator.path.count == 2)
    }

    @Test("pop removes the last route")
    func pop_removesLast() {
        let coordinator = AppCoordinator()
        coordinator.push(.movie(.detail(.testData)))

        coordinator.pop()

        #expect(coordinator.path.isEmpty)
    }

    @Test("pop on empty path is a no-op and does not crash")
    func pop_emptyPath() {
        let coordinator = AppCoordinator()

        coordinator.pop() // should not crash

        #expect(coordinator.path.isEmpty)
    }

    @Test("popToRoot clears entire path")
    func popToRoot_clearsPath() {
        let coordinator = AppCoordinator()
        coordinator.push(.movie(.detail(.testData)))
        coordinator.push(.movie(.images(movieId: 1, movieTitle: "Test")))
        coordinator.push(.movie(.reviews(movieId: 1, movieTitle: "Test")))

        coordinator.popToRoot()

        #expect(coordinator.path.isEmpty)
    }

    @Test("popToRoot on empty path is a no-op")
    func popToRoot_alreadyEmpty() {
        let coordinator = AppCoordinator()

        coordinator.popToRoot()

        #expect(coordinator.path.isEmpty)
    }
}
