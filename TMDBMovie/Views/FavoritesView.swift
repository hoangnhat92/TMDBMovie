import SwiftUI

struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        Group {
            if viewModel.movies.isEmpty {
                ContentUnavailableView("No Favorites", systemImage: "heart.slash", description: Text("Movies you favorite will appear here"))
            } else {
                List {
                    ForEach(viewModel.movies) { movie in
                        Button {
                            coordinator.push(.movieDetail(movie))
                        } label: {
                            MovieCardView(movie: movie)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.removeFavorite(viewModel.movies[index])
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        FavoritesView(
            viewModel: FavoritesViewModel(favoriteService: MockFavoriteService()),
            coordinator: AppCoordinator()
        )
    }
}
#endif
