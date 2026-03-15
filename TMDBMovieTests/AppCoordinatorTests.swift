import Testing
@testable import TMDBMovie

@Suite("AppCoordinator")
@MainActor
struct AppCoordinatorTests {

    // MARK: - Init

    @Test("selectedTab is trending on init")
    func init_selectedTabIsTrending() {
        let coordinator = AppCoordinator()

        #expect(coordinator.selectedTab == .trending)
    }

    @Test("all paths are empty on init")
    func init_allPathsEmpty() {
        let coordinator = AppCoordinator()

        #expect(coordinator.trendingPath.isEmpty)
        #expect(coordinator.searchPath.isEmpty)
        #expect(coordinator.favoritesPath.isEmpty)
    }

    @Test("sheet is nil on init")
    func init_sheetIsNil() {
        let coordinator = AppCoordinator()

        #expect(coordinator.sheet == nil)
    }

    // MARK: - Tab Selection

    @Test("selectTab changes selectedTab")
    func selectTab_changesSelectedTab() {
        let coordinator = AppCoordinator()

        coordinator.selectTab(.search)

        #expect(coordinator.selectedTab == .search)
    }

    // MARK: - Push

    @Test("push adds route to trending path when on trending tab")
    func push_trendingTab_addToTrendingPath() {
        let coordinator = AppCoordinator()
        coordinator.selectedTab = .trending

        coordinator.push(.movie(.detail(.testData)))

        #expect(coordinator.trendingPath.count == 1)
        #expect(coordinator.searchPath.isEmpty)
        #expect(coordinator.favoritesPath.isEmpty)
    }

    @Test("push adds route to search path when on search tab")
    func push_searchTab_addsToSearchPath() {
        let coordinator = AppCoordinator()
        coordinator.selectedTab = .search

        coordinator.push(.movie(.detail(.testData)))

        #expect(coordinator.trendingPath.isEmpty)
        #expect(coordinator.searchPath.count == 1)
        #expect(coordinator.favoritesPath.isEmpty)
    }

    @Test("push adds route to favorites path when on favorites tab")
    func push_favoritesTab_addsToFavoritesPath() {
        let coordinator = AppCoordinator()
        coordinator.selectedTab = .favorites

        coordinator.push(.movie(.detail(.testData)))

        #expect(coordinator.trendingPath.isEmpty)
        #expect(coordinator.searchPath.isEmpty)
        #expect(coordinator.favoritesPath.count == 1)
    }

    @Test("push multiple routes increments count on active tab path")
    func push_multipleRoutes_incrementsCount() {
        let coordinator = AppCoordinator()
        coordinator.selectedTab = .trending

        coordinator.push(.movie(.detail(.testData)))
        coordinator.push(.movie(.images(movieId: 1, movieTitle: "Test")))

        #expect(coordinator.trendingPath.count == 2)
    }

    // MARK: - Pop

    @Test("pop removes last route from active tab path")
    func pop_removesLast() {
        let coordinator = AppCoordinator()
        coordinator.selectedTab = .trending
        coordinator.push(.movie(.detail(.testData)))

        coordinator.pop()

        #expect(coordinator.trendingPath.isEmpty)
    }

    @Test("pop on empty path is a no-op and does not crash")
    func pop_emptyPath() {
        let coordinator = AppCoordinator()

        coordinator.pop()

        #expect(coordinator.trendingPath.isEmpty)
    }

    // MARK: - Pop to Root

    @Test("popToRoot clears active tab path")
    func popToRoot_clearsActivePath() {
        let coordinator = AppCoordinator()
        coordinator.selectedTab = .trending
        coordinator.push(.movie(.detail(.testData)))
        coordinator.push(.movie(.images(movieId: 1, movieTitle: "Test")))
        coordinator.push(.movie(.reviews(movieId: 1, movieTitle: "Test")))

        coordinator.popToRoot()

        #expect(coordinator.trendingPath.isEmpty)
    }

    @Test("popToRoot does not affect other tab paths")
    func popToRoot_doesNotAffectOtherTabs() {
        let coordinator = AppCoordinator()

        coordinator.selectedTab = .search
        coordinator.push(.movie(.detail(.testData)))

        coordinator.selectedTab = .trending
        coordinator.popToRoot()

        #expect(coordinator.searchPath.count == 1)
    }

    @Test("popToRoot on empty path is a no-op")
    func popToRoot_alreadyEmpty() {
        let coordinator = AppCoordinator()

        coordinator.popToRoot()

        #expect(coordinator.trendingPath.isEmpty)
    }

    // MARK: - Sheet

    @Test("presentSheet sets sheet route")
    func presentSheet_setsSheet() {
        let coordinator = AppCoordinator()

        coordinator.presentSheet(.movieDetail(.testData))

        #expect(coordinator.sheet == .movieDetail(.testData))
    }

    @Test("dismissSheet clears sheet")
    func dismissSheet_clearsSheet() {
        let coordinator = AppCoordinator()
        coordinator.presentSheet(.movieDetail(.testData))

        coordinator.dismissSheet()

        #expect(coordinator.sheet == nil)
    }
}
