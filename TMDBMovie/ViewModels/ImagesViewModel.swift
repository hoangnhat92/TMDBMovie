import Foundation

@Observable
final class ImagesViewModel {
    private(set) var backdrops: [MovieImage] = []
    private(set) var posters: [MovieImage] = []
    private(set) var isLoading = false
    private(set) var error: String?

    let movieId: Int
    let movieTitle: String
    private let movieService: any MovieServiceProtocol

    init(
        movieId: Int,
        movieTitle: String,
        movieService: any MovieServiceProtocol
    ) {
        self.movieId = movieId
        self.movieTitle = movieTitle
        self.movieService = movieService
    }

    func loadImages() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            let images = try await movieService.fetchMovieImages(id: movieId)
            backdrops = images.backdrops
            posters = images.posters
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
