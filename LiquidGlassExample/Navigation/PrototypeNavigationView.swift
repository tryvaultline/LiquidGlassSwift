import SwiftUI

struct PrototypeNavigationView: View {
    private enum Destination: Hashable {
        case videos
        case glass
    }

    @State private var selection: Destination = .videos

    var body: some View {
        TabView(selection: $selection) {
            VideoFeedView()
                .tabItem {
                    Label("Videos", systemImage: "play.rectangle.fill")
                }
                .tag(Destination.videos)

            MainView(quote: "Liquid Glass Example")
                .tabItem {
                    Label("Glass", systemImage: "sparkles")
                }
                .tag(Destination.glass)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    PrototypeNavigationView()
}
