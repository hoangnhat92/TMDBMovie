import SwiftUI

struct MoviePosterCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            CachedAsyncImage(url: movie.posterURL)
                .frame(width: 140, height: 210)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(movie.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(width: 140, alignment: .leading)

            HStack(spacing: 2) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption2)
                Text(movie.ratingText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MoviePosterCard(movie: .sampleData)
}
