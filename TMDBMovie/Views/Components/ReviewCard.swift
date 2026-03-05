import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let avatarURL = review.authorDetails?.avatarURL {
                    CachedAsyncImage(url: avatarURL)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.author)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(review.formattedDate)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if let rating = review.authorDetails?.rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption2)
                        Text(String(format: "%.0f", rating))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }

            Text(review.content)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(4)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ReviewCard(review: .sampleData)
}
