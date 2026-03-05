import Foundation

nonisolated struct Genre: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
}

nonisolated struct GenreResponse: Codable, Sendable {
    let genres: [Genre]
}
