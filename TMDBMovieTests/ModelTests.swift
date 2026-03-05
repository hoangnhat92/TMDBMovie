import Testing
@testable import TMDBMovie

// MARK: - Movie Model

@Suite("Movie Model")
struct MovieModelTests {

    @Test("posterURL returns w500 URL when posterPath is set")
    func posterURL_withPath() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: "/test.jpg",
            backdropPath: nil, releaseDate: nil, voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/test.jpg")
    }

    @Test("posterURL returns nil when posterPath is nil")
    func posterURL_nil() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: nil, voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.posterURL == nil)
    }

    @Test("backdropURL returns w780 URL when backdropPath is set")
    func backdropURL_withPath() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: "/backdrop.jpg", releaseDate: nil, voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.backdropURL?.absoluteString == "https://image.tmdb.org/t/p/w780/backdrop.jpg")
    }

    @Test("backdropURL returns nil when backdropPath is nil")
    func backdropURL_nil() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: nil, voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.backdropURL == nil)
    }

    @Test("year extracts first 4 characters from release date")
    func year_validDate() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: "2024-07-15", voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.year == "2024")
    }

    @Test("year returns N/A for nil release date")
    func year_nil() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: nil, voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.year == "N/A")
    }

    @Test("year returns N/A for a string shorter than 4 characters")
    func year_tooShort() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: "202", voteAverage: 0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.year == "N/A")
    }

    @Test("ratingText formats to one decimal place")
    func ratingText_oneDecimal() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: nil, voteAverage: 8.456, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.ratingText == "8.5")
    }

    @Test("ratingText formats zero correctly")
    func ratingText_zero() {
        let movie = Movie(
            id: 1, title: "T", overview: "", posterPath: nil,
            backdropPath: nil, releaseDate: nil, voteAverage: 0.0, voteCount: 0,
            genreIds: nil, genres: nil
        )

        #expect(movie.ratingText == "0.0")
    }
}

// MARK: - MovieImage Model

@Suite("MovieImage Model")
struct MovieImageModelTests {

    @Test("url returns w780 URL")
    func url_returns_w780() {
        let image = MovieImage(filePath: "/image.jpg", width: 1280, height: 720, aspectRatio: 1.78)

        #expect(image.url?.absoluteString == "https://image.tmdb.org/t/p/w780/image.jpg")
    }

    @Test("thumbnailURL returns w300 URL")
    func thumbnailURL_returns_w300() {
        let image = MovieImage(filePath: "/image.jpg", width: 1280, height: 720, aspectRatio: 1.78)

        #expect(image.thumbnailURL?.absoluteString == "https://image.tmdb.org/t/p/w300/image.jpg")
    }

    @Test("id equals filePath")
    func id_equalsFilePath() {
        let image = MovieImage(filePath: "/my_image.jpg", width: 500, height: 750, aspectRatio: 0.67)

        #expect(image.id == "/my_image.jpg")
    }
}

// MARK: - AuthorDetails Model

@Suite("AuthorDetails Model")
struct AuthorDetailsModelTests {

    @Test("avatarURL returns TMDB URL for relative path")
    func avatarURL_relativePath() {
        let details = AuthorDetails(name: "Nick", username: "nick", avatarPath: "/avatar.jpg", rating: 8.0)

        #expect(details.avatarURL?.absoluteString == "https://image.tmdb.org/t/p/w200/avatar.jpg")
    }

    @Test("avatarURL strips leading slash for external http paths")
    func avatarURL_externalHttpPath() {
        let details = AuthorDetails(name: "Nick", username: "nick", avatarPath: "/https://example.com/avatar.jpg", rating: nil)

        #expect(details.avatarURL?.absoluteString == "https://example.com/avatar.jpg")
    }

    @Test("avatarURL returns nil when avatarPath is nil")
    func avatarURL_nil() {
        let details = AuthorDetails(name: "Nick", username: "nick", avatarPath: nil, rating: nil)

        #expect(details.avatarURL == nil)
    }
}
