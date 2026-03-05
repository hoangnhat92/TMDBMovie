import Foundation

nonisolated enum APIEndpoint: Sendable {
        
    private static let baseURL = "https://api.themoviedb.org/3"
    private static let apiKey = Bundle.main.tmdbAPIKey
    
    case trending(page: Int)
    case search(query: String, page: Int)
    case movieDetail(id: Int)
    case movieImages(id: Int)
    case movieReviews(id: Int, page: Int)
    case genres

    var url: URL {
        var components = URLComponents(string: Self.baseURL + path)!
        var queryItems = [URLQueryItem(name: "api_key", value: Self.apiKey)]
        queryItems.append(contentsOf: additionalQueryItems)
        components.queryItems = queryItems
        return components.url!
    }

    private var path: String {
        switch self {
        case .trending:
            return "/trending/movie/week"
        case .search:
            return "/search/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieImages(let id):
            return "/movie/\(id)/images"
        case .movieReviews(let id, _):
            return "/movie/\(id)/reviews"
        case .genres:
            return "/genre/movie/list"
        }
    }

    private var additionalQueryItems: [URLQueryItem] {
        switch self {
        case .trending(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .movieReviews(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .movieDetail, .movieImages, .genres:
            return []
        }
    }
}
