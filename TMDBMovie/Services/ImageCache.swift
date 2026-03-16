import SwiftUI

protocol ImageCacheProtocol: Actor {
    func get(_ url: URL) -> UIImage?
    func set(_ image: UIImage, for url: URL)
}

actor ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    init() {
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }

    func get(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 0
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}

protocol ImageLoaderProtocol: Sendable {
    func loadImageData(from url: URL) async throws -> Data
}

struct URLSessionImageLoader: ImageLoaderProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImageData(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
}
