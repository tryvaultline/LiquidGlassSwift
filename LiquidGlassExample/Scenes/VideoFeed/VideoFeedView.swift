import SwiftUI

struct VideoFeedView: View {
    @State private var selectedPost: Int? = 0
    @State private var ratings: [Int: Int] = [:]

    private let titles = [
        "Liquid Glass Example",
        "Swipe through the feed",
        "Rate what you watch"
    ]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(titles.indices, id: \.self) { index in
                        VideoPage(
                            title: titles[index],
                            rating: ratingBinding(for: index),
                            canMoveUp: index > 0,
                            canMoveDown: index < titles.count - 1,
                            moveUp: { move(to: index - 1) },
                            moveDown: { move(to: index + 1) }
                        )
                        .containerRelativeFrame(.vertical)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $selectedPost)
            .navigationTitle("Videos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func move(to index: Int) {
        guard titles.indices.contains(index) else { return }
        withAnimation { selectedPost = index }
    }

    private func ratingBinding(for index: Int) -> Binding<Int?> {
        Binding(
            get: { ratings[index] },
            set: { rating in ratings[index] = rating }
        )
    }
}

private struct VideoPage: View {
    let title: String
    @Binding var rating: Int?
    let canMoveUp: Bool
    let canMoveDown: Bool
    let moveUp: () -> Void
    let moveDown: () -> Void

    var body: some View {
        ZStack {
            BackgroundView()

            HStack(alignment: .bottom, spacing: 20) {
                QuoteView(quote: title)
                    .frame(maxWidth: .infinity)

                VideoControls(
                    rating: $rating,
                    canMoveUp: canMoveUp,
                    canMoveDown: canMoveDown,
                    moveUp: moveUp,
                    moveDown: moveDown
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 112)
        }
    }
}

private struct VideoControls: View {
    @Binding var rating: Int?
    let canMoveUp: Bool
    let canMoveDown: Bool
    let moveUp: () -> Void
    let moveDown: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                controlButton("chevron.up", action: moveUp)
                    .disabled(!canMoveUp)

                Menu {
                    ForEach(1...5, id: \.self) { value in
                        Button("Rate \(value) stars") { rating = value }
                    }
                    Button("Clear rating") { rating = nil }
                } label: {
                    Image(systemName: rating == nil ? "star" : "star.fill")
                        .actionIcon(font: .headline)
                }
                .glassCircleButton(diameter: 52)

                controlButton("chevron.down", action: moveDown)
                    .disabled(!canMoveDown)
            }
        }
    }

    private func controlButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .actionIcon(font: .headline)
        }
        .glassCircleButton(diameter: 52)
    }
}

#Preview {
    VideoFeedView()
}
