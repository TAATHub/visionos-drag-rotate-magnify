import SwiftUI
import SwiftData
import RealityKit
import RealityKitContent

struct VolumeView: View {
    @State var viewModel = VolumeViewModel()
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
                
                scene.position.y = -0.3
                
                for craft in viewModel.crafts {
                    if let entity = scene.findEntity(named: craft.name) {
                        var position = craft.translation.simd3
                        position.y -= 0.3
                        
                        entity.setPosition(position, relativeTo: nil)
                        entity.setScale(craft.scale.simd3, relativeTo: nil)
                        entity.setOrientation(.init(vector: craft.orientation.simd4), relativeTo: nil)
                    }
                }
            }
        }
        .craftGesture(configuration: .init(positionRange: (x: -0.3...0.3, y: 0.0...0.3, z: -0.3...0.3),
                                           scaleRange: 0.5...1.5)) { craft in
            viewModel.saveCraft(craft)
        }
    }
}
