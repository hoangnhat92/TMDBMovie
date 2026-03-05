import SwiftUI

enum Route: Hashable {
    case movie(MovieRoute)

    enum MovieRoute: Hashable {
        case detail(Movie)
        case images(movieId: Int, movieTitle: String)
        case reviews(movieId: Int, movieTitle: String)
    }
}

@Observable
final class AppCoordinator {
    var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
