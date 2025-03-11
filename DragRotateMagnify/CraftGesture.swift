import SwiftUI
import RealityKit

/// A gesture modifier handling drag, rotate, magnify gestures.
struct CraftGesture: ViewModifier {
    
    struct Configuration {
        /// The position range that the entity can be dragged
        var positionRange: (x: ClosedRange<Float>, y: ClosedRange<Float>, z: ClosedRange<Float>)
        /// The scale range that the entity can be magnified
        var scaleRange: ClosedRange<Float>
    }

    @State var isActive: Bool = false
    @State var initialPosition: SIMD3<Float> = .zero
    @State var initialScale: SIMD3<Float> = .one
    @State var initialOrientation:simd_quatf = simd_quatf(vector: .zero)

    var configuration: Configuration
    var onGestureEnded: (Craft) -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(dragGesture)
            .gesture(rotateAndMagnifyGesture)
    }
    
    /// Drag gesture
    ///
    /// See also [Improved Drag Gesture](https://stepinto.vision/example-code/improved-drag-gesture/)
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                startGesture(with: value.entity)
                
                // Update position from drag gesture
                let movement = value.convert(value.gestureValue.translation3D, from: .local, to: .scene)
                let newPosition = initialPosition + movement

                if let collision = value.entity.components[CollisionComponent.self],
                   let shapeResource = collision.shapes.first {
                    // Clamp the entity position with the collision bounds and configuration
                    value.entity.position = clampedPosition(newPosition,
                                                            scale: value.entity.scale,
                                                            extents: shapeResource.bounds.extents,
                                                            configuration: configuration)
                } else {
                    value.entity.position = newPosition
                }
            }
            .onEnded { value in
                endGesture()
                onGestureEnded(.init(entity: value.entity))
            }
    }
    
    /// Simultaneously combined rotate and magnify gesture
    ///
    /// See also [Simultaneously Combine Gestures](https://stepinto.vision/example-code/simultaneously-combine-gestures/)
    var rotateAndMagnifyGesture: some Gesture {
        RotateGesture3D(constrainedToAxis: .y)
            .simultaneously(with: MagnifyGesture())
            .targetedToAnyEntity()
            .onChanged { value in
                startGesture(with: value.entity)
                
                guard initialOrientation.length > 0 else { return }
                
                if let rotation = value.first?.rotation, let magnification = value.second?.magnification {
                    // Update rotation from rotate gesture
                    let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                    value.entity.orientation = initialOrientation * rotationTransform.rotation
                    
                    // Update scale from magnify gesture
                    let newScale = initialScale * Float(magnification)
                    value.entity.scale = clampedScale(newScale, configuration: configuration)
                }

            }
            .onEnded { value in
                endGesture()
                onGestureEnded(.init(entity: value.entity))
            }
    }
    
    private func clampedPosition(_ position: SIMD3<Float>, scale: SIMD3<Float>, extents: SIMD3<Float>, configuration: Configuration) -> SIMD3<Float> {
        let minX = configuration.positionRange.x.lowerBound + extents.x * scale.x / 2
        let maxX = configuration.positionRange.x.upperBound - extents.x * scale.x / 2
        let minY: Float = configuration.positionRange.y.lowerBound
        let maxY: Float = configuration.positionRange.y.upperBound
        let minZ = configuration.positionRange.z.lowerBound + extents.z * scale.z / 2
        let maxZ = configuration.positionRange.z.upperBound - extents.z * scale.z / 2

        let x = min(max(position.x, minX), maxX)
        let y = min(max(position.y, minY), maxY)
        let z = min(max(position.z, minZ), maxZ)
        return .init(x: x, y: y, z: z)
    }
    
    private func clampedScale(_ scale: SIMD3<Float>, configuration: Configuration) -> SIMD3<Float> {
        scale.clamped(lowerBound: .init(repeating: configuration.scaleRange.lowerBound),
                      upperBound: .init(repeating: configuration.scaleRange.upperBound))
    }
    
    private func startGesture(with entity: Entity) {
        guard !isActive else { return }
        
        isActive = true
        
        // Cache the entity's initial position, scale and rotation
        initialPosition = entity.position
        initialScale = entity.scale
        initialOrientation = entity.transform.rotation
    }
    
    private func endGesture() {
        guard isActive else { return }
        
        isActive = false
        
        // Reset the entity's initial position, scale and rotation
        initialPosition = .zero
        initialScale = .one
        initialOrientation = simd_quatf(vector: .zero)
    }
}

extension View {
    func craftGesture(configuration: CraftGesture.Configuration, onGestureEnded: @escaping (Craft) -> Void) -> some View {
        modifier(CraftGesture(configuration: configuration, onGestureEnded: onGestureEnded))
    }
}
