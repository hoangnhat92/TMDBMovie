import SwiftUI

extension EnvironmentValues {
    @Entry var movieService: any MovieServiceProtocol = UnimplementedMovieService()
    @Entry var favoriteService: any FavoriteServiceProtocol = UnimplementedFavoriteService()
    @Entry var imageCache: any ImageCacheProtocol = ImageCache.shared
    @Entry var imageLoader: any ImageLoaderProtocol = URLSessionImageLoader()
}
