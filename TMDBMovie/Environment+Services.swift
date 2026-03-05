import SwiftUI

extension EnvironmentValues {
    @Entry var movieService: any MovieServiceProtocol = UnimplementedMovieService()
    @Entry var favoriteService: any FavoriteServiceProtocol = UnimplementedFavoriteService()
}
