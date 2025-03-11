import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.openWindow) var openWindow

    var body: some View {
        VStack(spacing: 64) {
            Text("Drag Rotate Magnify")
                .font(.largeTitle)

            Button("Show Volume") {
                openWindow(id: appModel.volumeWindowID)
            }
        }
        .padding()
        .frame(width: 400, height: 400)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
