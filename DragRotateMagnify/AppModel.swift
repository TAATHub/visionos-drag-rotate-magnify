import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let volumeWindowID = "VolumeWindow"
    let immersiveSpaceID = "ImmersiveSpace"
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
