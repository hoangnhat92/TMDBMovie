import SwiftUI

struct TrendingView: View {
    @State var viewModel: TrendingViewModel
    @State var query: String = ""
    @Bindable var coordinator: AppCoordinator
    
    private var filteredMovies: [Movie] {
        if query.isEmpty {
            return viewModel.movies
        } else {
            return viewModel.movies.filter {
                $0.title.localizedCaseInsensitiveContains(query)
            }
        }
    }

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
        .searchable(text: $query)
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
                ForEach(filteredMovies) { movie in
                    Button {
                        coordinator.push(.movieDetail(movie))
                    } label: {
                        MovieCardView(movie: movie)
                            .padding(.horizontal)
                            .contentShape(Rectangle())
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

#if DEBUG
#Preview {
    NavigationStack {
        TrendingView(
            viewModel: TrendingViewModel(movieService: MockMovieService()),
            coordinator: AppCoordinator()
        )
    }
}
#endif
