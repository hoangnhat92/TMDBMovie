import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
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
