import Foundation

nonisolated struct Review: Codable, Identifiable, Sendable {
    let id: String
    let author: String
    let content: String
    let createdAt: String
    let authorDetails: AuthorDetails?

    enum CodingKeys: String, CodingKey {
        case id, author, content
        case createdAt = "created_at"
        case authorDetails = "author_details"
    }

    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: createdAt) else {
            formatter.formatOptions = [.withInternetDateTime]
            guard let date = formatter.date(from: createdAt) else { return "" }
            return Self.displayFormatter.string(from: date)
        }
        return Self.displayFormatter.string(from: date)
    }

    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
}

nonisolated struct AuthorDetails: Codable, Sendable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case name, username, rating
        case avatarPath = "avatar_path"
    }

    var avatarURL: URL? {
        guard let avatarPath else { return nil }
        if avatarPath.hasPrefix("/http") {
            return URL(string: String(avatarPath.dropFirst()))
        }
        return URL(string: "https://image.tmdb.org/t/p/w200\(avatarPath)")
    }
}


#if DEBUG
extension Review {
    static let sampleData = Review(
        id: "1223",
        author: "Nick",
        content: "This is a good movie",
        createdAt: "",
        authorDetails: AuthorDetails(name: "Nick", username: "nick@", avatarPath: "", rating: 5.0)
    )
}
#endif
