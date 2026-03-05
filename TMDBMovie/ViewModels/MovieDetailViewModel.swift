import Foundation

@Observable
final class MovieDetailViewModel {
    private(set) var movie: Movie
    private(set) var images: MovieImages?
    private(set) var reviews: [Review] = []
    private(set) var isLoading = false
    private(set) var isFavorite = false
    private(set) var error: String?

    private let movieService: MovieServiceProtocol
    private let favoriteService: FavoriteServiceProtocol

    init(
        movie: Movie,
        movieService: MovieServiceProtocol = MovieService(),
        favoriteService: FavoriteServiceProtocol = FavoriteService()
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
            movie = try await movieService.fetchMovieDetail(id: movie.id)
            images = try await movieService.fetchMovieImages(id: movie.id)
            let reviewsResponse = try await movieService.fetchMovieReviews(id: movie.id, page: 1)
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
