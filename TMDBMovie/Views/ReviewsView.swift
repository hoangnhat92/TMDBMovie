import SwiftUI

struct ReviewsView: View {
    @State var viewModel: ReviewsViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.reviews.isEmpty {
                ProgressView("Loading reviews...")
            } else if viewModel.reviews.isEmpty {
                ContentUnavailableView("No Reviews", systemImage: "text.bubble", description: Text("No reviews yet for this movie"))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.reviews) { review in
                            ReviewCard(review: review)
                        }

                        if viewModel.canLoadMore {
                            ProgressView()
                                .padding()
                                .task {
                                    await viewModel.loadMore()
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Reviews")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.reviews.isEmpty {
                await viewModel.loadReviews()
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ReviewsView(
            viewModel: ReviewsViewModel(
                movieId: 1,
                movieTitle: "Movie 1",
                movieService: MockMovieService()
            )
        )
    }
}
#endif
