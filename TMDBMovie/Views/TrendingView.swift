import SwiftUI

struct TrendingView: View {
    @State var viewModel: TrendingViewModel
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.movies.isEmpty {
                ProgressView("Loading trending movies...")
            } else if let error = viewModel.error, viewModel.movies.isEmpty {
                ContentUnavailableView {
                    Label("Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                } actions: {
                    Button("Retry") {
                        Task { await viewModel.loadTrending() }
                    }
                }
            } else {
                movieList
            }
        }
        .navigationTitle("Trending")
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.loadTrending()
            }
        }
        .refreshable {
            await viewModel.loadTrending()
        }
    }

    private var movieList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.movies) { movie in
                    Button {
                        coordinator.push(.movieDetail(movie))
                    } label: {
                        MovieCardView(movie: movie)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                    
                    Divider().padding(.leading)
                }

                if viewModel.canLoadMore {
                    ProgressView()
                        .padding()
                        .task {
                            await viewModel.loadMore()
                        }
                }
            }
        }
    }
}
