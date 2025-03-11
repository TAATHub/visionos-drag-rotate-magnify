import SwiftUI

@main
struct DragRotateMagnifyApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        
        WindowGroup(id: appModel.volumeWindowID) {
            VolumeView()
                .environment(appModel)
                .frame(width: 1500, height: 1500)
                .frame(depth: 1500)
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
