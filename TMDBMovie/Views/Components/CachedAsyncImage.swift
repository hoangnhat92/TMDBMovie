import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    @Environment(\.imageCache) private var cache
    @Environment(\.imageLoader) private var loader

    @State private var image: UIImage?
    @State private var isFailed = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isFailed {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
        .task(id: url) {
            await loadImage()
        }
        .onDisappear {
            image = nil
        }
    }

    private func loadImage() async {
        isFailed = false
        image = nil

        guard let url else {
            isFailed = true
            return
        }

        if let cached = await cache.get(url) {
            image = cached
            return
        }

        do {
            let data = try await loader.loadImageData(from: url)
            guard let downloaded = UIImage(data: data) else {
                isFailed = true
                return
            }
            await cache.set(downloaded, for: url)
            image = downloaded
        } catch {
            isFailed = true
        }
    }
}

#Preview {
    CachedAsyncImage(
        url: URL(string: "https://picsum.photos/200/300"),
        contentMode: .fill
    )
    .frame(width: 200, height: 300)
}
