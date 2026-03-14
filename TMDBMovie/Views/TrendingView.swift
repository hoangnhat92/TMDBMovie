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
        List {
            ForEach(filteredMovies) { movie in
                Button {
                    coordinator.push(.movie(.detail(movie)))
                } label: {
                    MovieCardView(movie: movie)
                }
                .buttonStyle(.plain)
            }

            if viewModel.canLoadMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .listRowSeparator(.hidden)
                    .task {
                        await viewModel.loadMore()
                    }
            }
        }
        .listStyle(.plain)
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
    .environment(\.movieService, MockMovieService())
}
#endif
