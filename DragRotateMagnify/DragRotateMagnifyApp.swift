import SwiftUI

@main
struct DragRotateMagnifyApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .windowResizability(.contentSize)
        
        WindowGroup(id: appModel.volumeWindowID) {
            VolumeView()
                .environment(appModel)
                .frame(width: 1000, height: 1000)
                .frame(depth: 1000)
                .modelContainer(for: Craft.self)
        }
        .windowStyle(.volumetric)
        .windowResizability(.contentSize)
        .volumeWorldAlignment(.gravityAligned)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
