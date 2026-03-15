import SwiftUI

struct MovieDetailView: View {
    @State var viewModel: MovieDetailViewModel
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                backdropSection
                movieInfoSection
                genresSection
                overviewSection
                imagesPreviewSection
                reviewsPreviewSection
            }
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? .red : .primary)
                }
            }
        }
        .task {
            await viewModel.loadDetail()
        }
    }

    private var backdropSection: some View {
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(url: viewModel.movie.backdropURL)
                .frame(height: 220)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text(viewModel.movie.year)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding()
        }
    }

    private var movieInfoSection: some View {
        HStack(spacing: 20) {
            CachedAsyncImage(url: viewModel.movie.posterURL)
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(viewModel.movie.ratingText)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("(\(viewModel.movie.voteCount))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let releaseDate = viewModel.movie.releaseDate {
                    Label(releaseDate, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var genresSection: some View {
        if let genres = viewModel.movie.genres, !genres.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(genres) { genre in
                        Text(genre.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            Text(viewModel.movie.overview)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var imagesPreviewSection: some View {
        if let images = viewModel.images,
           !images.backdrops.isEmpty || !images.posters.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Images")
                        .font(.headline)
                    Spacer()
                    Button("See All") {
                        coordinator.push(.movie(.images(
                            movieId: viewModel.movie.id,
                            movieTitle: viewModel.movie.title
                        )))
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(images.backdrops.prefix(10)) { image in
                            CachedAsyncImage(url: image.thumbnailURL)
                                .frame(width: 200, height: 112)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    @ViewBuilder
    private var reviewsPreviewSection: some View {
        if !viewModel.reviews.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Reviews")
                        .font(.headline)
                    Spacer()
                    Button("See All") {
                        coordinator.push(.movie(.reviews(
                            movieId: viewModel.movie.id,
                            movieTitle: viewModel.movie.title
                        )))
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)

                ForEach(viewModel.reviews.prefix(2)) { review in
                    ReviewCard(review: review)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        MovieDetailView(
            viewModel: MovieDetailViewModel(
                movie: .sampleData,
                movieService: MockMovieService(),
                favoriteService: MockFavoriteService()
            )
        )
    }
    .environment(AppCoordinator())
    .environment(\.movieService, MockMovieService())
    .environment(\.favoriteService, MockFavoriteService())
}
#endif
