import XCTest

@MainActor
final class TMDBMovieUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false        
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tab Bar

    func testTabBar_threeTabsAreVisible() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)

        XCTAssertTrue(app.tabBars.buttons["Trending"].exists)
        XCTAssertTrue(app.tabBars.buttons["Search"].exists)
        XCTAssertTrue(app.tabBars.buttons["Favorites"].exists)
    }

    func testTabBar_defaultTabIsTrending() {
        let trendingButton = app.tabBars.buttons["Trending"]
        XCTAssertTrue(trendingButton.isSelected)
    }

    func testTabBar_switchToSearch() {
        app.tabBars.buttons["Search"].tap()

        let searchButton = app.tabBars.buttons["Search"]
        XCTAssertTrue(searchButton.isSelected)
    }

    func testTabBar_switchToFavorites() {
        app.tabBars.buttons["Favorites"].tap()

        let favoritesButton = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesButton.isSelected)
    }

    func testTabBar_switchBetweenAllTabs() {
        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.tabBars.buttons["Search"].isSelected)

        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.tabBars.buttons["Favorites"].isSelected)

        app.tabBars.buttons["Trending"].tap()
        XCTAssertTrue(app.tabBars.buttons["Trending"].isSelected)
    }

    // MARK: - Trending Tab

    func testTrendingTab_hasNavigationTitle() {
        XCTAssertTrue(app.navigationBars["Trending"].exists)
    }

    func testTrendingTab_hasSearchBar() {
        XCTAssertTrue(app.searchFields.firstMatch.exists)
    }

    // MARK: - Search Tab

    func testSearchTab_hasSearchField() {
        app.tabBars.buttons["Search"].tap()

        XCTAssertTrue(app.searchFields.firstMatch.exists)
    }

    func testSearchTab_canTypeQuery() {
        app.tabBars.buttons["Search"].tap()

        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Batman")

        XCTAssertEqual(searchField.value as? String, "Batman")
    }

    func testSearchTab_clearQueryShowsEmptyState() {
        app.tabBars.buttons["Search"].tap()

        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Batman")

        let clearButton = searchField.buttons["Clear text"]
        if clearButton.exists {
            clearButton.tap()
        }

        XCTAssertEqual(searchField.value as? String, "Search movies...")
    }

    // MARK: - Favorites Tab

    func testFavoritesTab_hasNavigationTitle() {
        app.tabBars.buttons["Favorites"].tap()

        XCTAssertTrue(app.navigationBars["Favorites"].exists)
    }
}
