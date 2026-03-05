import SwiftUI

enum Route: Hashable {
    case movieDetail(Movie)
    case movieImages(movieId: Int, movieTitle: String)
    case movieReviews(movieId: Int, movieTitle: String)
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
