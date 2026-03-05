import SwiftUI

struct ImagesView: View {
    @State var viewModel: ImagesViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading images...")
            } else if viewModel.backdrops.isEmpty && viewModel.posters.isEmpty {
                ContentUnavailableView("No Images", systemImage: "photo.on.rectangle", description: Text("No images available"))
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !viewModel.backdrops.isEmpty {
                            imageSection(title: "Backdrops", images: viewModel.backdrops)
                        }
                        if !viewModel.posters.isEmpty {
                            imageSection(title: "Posters", images: viewModel.posters)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Images")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.backdrops.isEmpty && viewModel.posters.isEmpty {
                await viewModel.loadImages()
            }
        }
    }

    private func imageSection(title: String, images: [MovieImage]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(images) { image in
                        CachedAsyncImage(url: image.url)
                            .frame(
                                width: title == "Posters" ? 150 : 280,
                                height: title == "Posters" ? 225 : 158
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ImagesView(
            viewModel: ImagesViewModel(
                movieId: 1,
                movieTitle: "Movie 1",
                movieService: MockMovieService()
            )
        )
    }
    .environment(\.movieService, MockMovieService())
}
#endif
