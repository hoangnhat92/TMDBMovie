import Foundation

@Observable
final class MovieDetailViewModel {
    private(set) var movie: Movie
    private(set) var images: MovieImages?
    private(set) var reviews: [Review] = []
    private(set) var isLoading = false
    private(set) var isFavorite = false
    private(set) var error: String?

    private let movieService: any MovieServiceProtocol
    private let favoriteService: any FavoriteServiceProtocol

    init(
        movie: Movie,
        movieService: any MovieServiceProtocol,
        favoriteService: any FavoriteServiceProtocol
    ) {
        self.movie = movie
        self.movieService = movieService
        self.favoriteService = favoriteService
        self.isFavorite = favoriteService.isFavorite(movie)
    }

    func loadDetail() async {
        isLoading = true
        error = nil

        do {
            async let detailTask = movieService.fetchMovieDetail(id: movie.id)
            async let imagesTask = movieService.fetchMovieImages(id: movie.id)
            async let reviewsTask = movieService.fetchMovieReviews(id: movie.id, page: 1)

            let (detail, imgs, reviewsResponse) = try await (detailTask, imagesTask, reviewsTask)
            movie = detail
            images = imgs
            reviews = reviewsResponse.results
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func toggleFavorite() {
        if isFavorite {
            favoriteService.removeFavorite(movie)
        } else {
            favoriteService.addFavorite(movie)
        }
        isFavorite.toggle()
    }
}
