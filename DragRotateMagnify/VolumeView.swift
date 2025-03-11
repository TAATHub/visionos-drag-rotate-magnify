import SwiftUI
import RealityKit
import RealityKitContent

struct VolumeView: View {
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
                
                scene.position.y = -0.48
            }
        }
    }
}
