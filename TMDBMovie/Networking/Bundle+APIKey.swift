import Foundation

extension Bundle {
    nonisolated var tmdbAPIKey: String {
        guard let key = object(forInfoDictionaryKey: "TMDBAPIKey") as? String,
              !key.isEmpty,
              key != "YOUR_API_KEY_HERE"
        else {
            fatalError("TMDB API key not found. Copy Secrets.xcconfig.example to Secrets.xcconfig and add your key.")
        }
        return key
    }
}
