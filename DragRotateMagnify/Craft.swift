import SwiftData
import RealityKit

@Model
class Craft {
    @Attribute(.unique) var name: String
    
    // Due to the following issue, it seems that we cannot store a single SIMD3<Float> with SwiftData currently.
    // https://developer.apple.com/forums/thread/763634
    var translation: CraftTranslation
    var scale: CraftScale
    var orientation: CraftOrientation
    
    init(name: String, translation: CraftTranslation, scale: CraftScale, orientation: CraftOrientation) {
        self.name = name
        self.translation = translation
        self.scale = scale
        self.orientation = orientation
    }
    
    init(entity: Entity) {
        self.name = entity.name
        self.translation = .init(entity.transform.translation)
        self.scale = .init(entity.scale)
        self.orientation = .init(entity.orientation.vector)
    }
}

struct CraftTranslation: Codable {
    var x: Float
    var y: Float
    var z: Float
    
    init(_ translation: SIMD3<Float>) {
        self.x = translation.x
        self.y = translation.y
        self.z = translation.z
    }
    
    var simd3: SIMD3<Float> {
        .init(x, y, z)
    }
}

struct CraftScale: Codable {
    var x: Float
    var y: Float
    var z: Float
    
    init(_ scale: SIMD3<Float>) {
        self.x = scale.x
        self.y = scale.y
        self.z = scale.z
    }
    
    var simd3: SIMD3<Float> {
        .init(x, y, z)
    }
}

struct CraftOrientation: Codable {
    var x: Float
    var y: Float
    var z: Float
    var w: Float
    
    init(_ orientation: SIMD4<Float>) {
        self.x = orientation.x
        self.y = orientation.y
        self.z = orientation.z
        self.w = orientation.w
    }
    
    var simd4: SIMD4<Float> {
        .init(x, y, z, w)
    }
}
