import SwiftUI

struct SearchView: View {
    @State var viewModel: SearchViewModel
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.movies.isEmpty && !viewModel.isLoading && viewModel.query.isEmpty {
                ContentUnavailableView("Search Movies", systemImage: "magnifyingglass", description: Text("Enter a movie title to search"))
            } else if viewModel.movies.isEmpty && !viewModel.isLoading && !viewModel.query.isEmpty {
                ContentUnavailableView.search(text: viewModel.query)
            } else if viewModel.isLoading && viewModel.movies.isEmpty {
                ProgressView("Searching...")
            } else {
                movieList
            }
        }
        .navigationTitle("Search")
        .searchable(text: $viewModel.query, prompt: "Search movies...")
        .onChange(of: viewModel.query) {
            viewModel.search()
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
