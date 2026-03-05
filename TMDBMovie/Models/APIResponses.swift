import Foundation

nonisolated struct PagedResponse<T: Codable & Sendable>: Codable, Sendable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

nonisolated struct MovieImages: Codable, Sendable {
    let backdrops: [MovieImage]
    let posters: [MovieImage]
}

nonisolated struct MovieImage: Codable, Identifiable, Sendable {
    let filePath: String
    let width: Int
    let height: Int
    let aspectRatio: Double

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case width, height
        case aspectRatio = "aspect_ratio"
    }

    var id: String { filePath }

    var url: URL? {
        URL(string: "https://image.tmdb.org/t/p/w780\(filePath)")
    }

    var thumbnailURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w300\(filePath)")
    }
}
