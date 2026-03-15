import Testing
import UIKit
@testable import TMDBMovie

@Suite("ImageCache")
struct ImageCacheTests {

    private func makeSUT() -> ImageCache {
        ImageCache()
    }

    private func makeImage(color: UIColor = .red, size: CGSize = CGSize(width: 10, height: 10)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    private func makeURL(_ path: String = UUID().uuidString) -> URL {
        URL(string: "https://example.com/\(path).jpg")!
    }

    // MARK: - get

    @Test("get returns nil for uncached URL")
    func get_returnsNil_whenNotCached() async {
        let cache = makeSUT()

        let result = await cache.get(makeURL())

        #expect(result == nil)
    }

    // MARK: - set & get

    @Test("set then get returns the cached image")
    func setAndGet_returnsCachedImage() async {
        let cache = makeSUT()
        let url = makeURL()
        let image = makeImage()

        await cache.set(image, for: url)
        let result = await cache.get(url)

        #expect(result != nil)
        #expect(result === image)
    }

    @Test("different URLs return different images")
    func differentURLs_returnDifferentImages() async {
        let cache = makeSUT()
        let url1 = makeURL("image1")
        let url2 = makeURL("image2")
        let image1 = makeImage(color: .red)
        let image2 = makeImage(color: .blue)

        await cache.set(image1, for: url1)
        await cache.set(image2, for: url2)

        let result1 = await cache.get(url1)
        let result2 = await cache.get(url2)

        #expect(result1 === image1)
        #expect(result2 === image2)
    }

    @Test("setting a new image for the same URL overwrites the previous one")
    func set_overwritesPreviousImage() async {
        let cache = makeSUT()
        let url = makeURL()
        let original = makeImage(color: .red)
        let replacement = makeImage(color: .blue)

        await cache.set(original, for: url)
        await cache.set(replacement, for: url)
        let result = await cache.get(url)

        #expect(result === replacement)
    }

    @Test("each cache instance is independent")
    func separateInstances_areIndependent() async {
        let cache1 = makeSUT()
        let cache2 = makeSUT()
        let url = makeURL()
        let image = makeImage()

        await cache1.set(image, for: url)

        let result = await cache2.get(url)
        #expect(result == nil)
    }
}
