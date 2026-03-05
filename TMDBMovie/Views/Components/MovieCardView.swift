import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: movie.posterURL)
                .frame(width: 80, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(movie.year)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    Text(movie.ratingText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieCardView(movie: .sampleData)
}
