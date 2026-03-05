//
//  Movie+SampleData.swift
//  TMDBMovie
//
//  Created by nhat on 5/3/26.
//

import Foundation

#if DEBUG
extension Movie {
    static let sampleData = Movie(
        id: 1,
        title: "Movie 1",
        overview: "Lorem ispem",
        posterPath: "/sojEzvfxR2DBcDSJyAisX8TWjov.jpg",
        backdropPath: "/hYgUkH7TusddHRtelj53I6gFOWR.jpg",
        releaseDate: "2026/12/31",
        voteAverage: 5.0,
        voteCount: 100,
        genreIds: [],
        genres: []
    )

    static let sampleList: [Movie] = [
        sampleData,
        Movie(
            id: 2,
            title: "The Dark Knight",
            overview: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
            posterPath: "/qJ2tW6WMUDux911BTUgMEb1IP9W.jpg",
            backdropPath: "/nMKdUUepR0i5zn0y1T4CsSB5ez.jpg",
            releaseDate: "2008-07-16",
            voteAverage: 8.5,
            voteCount: 31520,
            genreIds: [18, 28, 80],
            genres: [Genre(id: 18, name: "Drama"), Genre(id: 28, name: "Action"), Genre(id: 80, name: "Crime")]
        ),
        Movie(
            id: 3,
            title: "Inception",
            overview: "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets is offered a chance to regain his old life as payment for a task considered to be impossible.",
            posterPath: "/ljsZTbVsrQSqZgWeep2B1QiDKuh.jpg",
            backdropPath: "/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg",
            releaseDate: "2010-07-15",
            voteAverage: 8.4,
            voteCount: 35280,
            genreIds: [28, 878, 12],
            genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Science Fiction"), Genre(id: 12, name: "Adventure")]
        ),
        Movie(
            id: 4,
            title: "Interstellar",
            overview: "The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage.",
            posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
            backdropPath: "/xJHokMbljvjADYdit5fK1DDNfOp.jpg",
            releaseDate: "2014-11-05",
            voteAverage: 8.4,
            voteCount: 33640,
            genreIds: [12, 18, 878],
            genres: [Genre(id: 12, name: "Adventure"), Genre(id: 18, name: "Drama"), Genre(id: 878, name: "Science Fiction")]
        ),
        Movie(
            id: 5,
            title: "Pulp Fiction",
            overview: "A burger-loving hit man, his philosophical partner, a drug-addled gangster's moll and a washed-up boxer converge in this sprawling, comedic crime caper.",
            posterPath: "/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg",
            backdropPath: "/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg",
            releaseDate: "1994-09-10",
            voteAverage: 8.5,
            voteCount: 26750,
            genreIds: [53, 80],
            genres: [Genre(id: 53, name: "Thriller"), Genre(id: 80, name: "Crime")]
        ),
        Movie(
            id: 6,
            title: "The Shawshank Redemption",
            overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison.",
            posterPath: "/9cjIGRQL0PQa4UPTCkfGiIyH4NL.jpg",
            backdropPath: "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
            releaseDate: "1994-09-23",
            voteAverage: 8.7,
            voteCount: 26120,
            genreIds: [18, 80],
            genres: [Genre(id: 18, name: "Drama"), Genre(id: 80, name: "Crime")]
        ),
        Movie(
            id: 7,
            title: "The Matrix",
            overview: "Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.",
            posterPath: "/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
            backdropPath: "/fNG7i7RqMErkcqhohV2a2icgKho.jpg",
            releaseDate: "1999-03-30",
            voteAverage: 8.2,
            voteCount: 24530,
            genreIds: [28, 878],
            genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Science Fiction")]
        ),
        Movie(
            id: 8,
            title: "Forrest Gump",
            overview: "A man with a low IQ has accomplished great things in his life and been present during significant historic events — in each case, far exceeding what anyone imagined he could do.",
            posterPath: "/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg",
            backdropPath: "/ghgfzbEV7kbpbi1O3sCBrp6MbLT.jpg",
            releaseDate: "1994-06-23",
            voteAverage: 8.5,
            voteCount: 26340,
            genreIds: [35, 18, 10749],
            genres: [Genre(id: 35, name: "Comedy"), Genre(id: 18, name: "Drama"), Genre(id: 10749, name: "Romance")]
        ),
        Movie(
            id: 9,
            title: "Parasite",
            overview: "All unemployed, Ki-taek's family takes peculiar interest in the wealthy and glamorous Parks for their livelihood until they get entangled in an unexpected incident.",
            posterPath: "/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
            backdropPath: "/TU9aKQfUKmpIIHsFSdBg3Y9bY1W.jpg",
            releaseDate: "2019-05-30",
            voteAverage: 8.5,
            voteCount: 17250,
            genreIds: [35, 53, 18],
            genres: [Genre(id: 35, name: "Comedy"), Genre(id: 53, name: "Thriller"), Genre(id: 18, name: "Drama")]
        ),
        Movie(
            id: 10,
            title: "Dune: Part Two",
            overview: "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family.",
            posterPath: "/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg",
            backdropPath: "/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg",
            releaseDate: "2024-02-27",
            voteAverage: 8.2,
            voteCount: 5840,
            genreIds: [878, 12],
            genres: [Genre(id: 878, name: "Science Fiction"), Genre(id: 12, name: "Adventure")]
        ),
    ]
}
#endif
