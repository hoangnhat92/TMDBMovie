import SwiftUI

@main
struct TMDBMovieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.movieService, MovieService())
                .environment(\.favoriteService, FavoriteService())
        }
    }
}
