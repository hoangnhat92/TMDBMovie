import SwiftUI

enum Tab: Hashable {
    case trending
    case search
    case favorites
}

enum Route: Hashable {
    case movie(MovieRoute)
    
    enum MovieRoute: Hashable {
        case detail(Movie)
        case images(movieId: Int, movieTitle: String)
        case reviews(movieId: Int, movieTitle: String)
    }
}

enum SheetRoute: Identifiable, Hashable {
    case movieDetail(Movie)
    
    var id: Int {
        switch self {
        case .movieDetail(let movie): movie.id
        }
    }
}

@Observable
final class AppCoordinator {
    var selectedTab: Tab = .trending
    var trendingPath = NavigationPath()
    var searchPath = NavigationPath()
    var favoritesPath = NavigationPath()
    var sheet: SheetRoute?
    
    // MARK: - Tab
    
    func selectTab(_ tab: Tab) {
        selectedTab = tab
    }
    
    // MARK: - Stack Navigation
    
    func push(_ route: Route) {
        switch selectedTab {
        case .trending: trendingPath.append(route)
        case .search: searchPath.append(route)
        case .favorites: favoritesPath.append(route)
        }
    }
    
    func pop() {
        switch selectedTab {
        case .trending: if !trendingPath.isEmpty { trendingPath.removeLast() }
        case .search: if !searchPath.isEmpty { searchPath.removeLast() }
        case .favorites: if !favoritesPath.isEmpty { favoritesPath.removeLast() }
        }
    }
    
    func popToRoot() {
        switch selectedTab {
        case .trending: trendingPath = NavigationPath()
        case .search: searchPath = NavigationPath()
        case .favorites: favoritesPath = NavigationPath()
        }
    }
    
    // MARK: - Sheet
    
    func presentSheet(_ route: SheetRoute) {
        sheet = route
    }
    
    func dismissSheet() {
        sheet = nil
    }
}
