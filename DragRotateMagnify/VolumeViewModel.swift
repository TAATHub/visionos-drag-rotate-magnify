import Observation

@Observable
@MainActor
final class VolumeViewModel {
    @ObservationIgnored
    private let dataSource: CraftDataSource = CraftDataSource.shared

    var crafts: [Craft] = []

    init() {
        crafts = dataSource.fetchCrafts()
    }
    
    func saveCraft(_ craft: Craft) {
        if let index = crafts.firstIndex(where: { $0.name == craft.name }) {
            crafts[index].translation = craft.translation
            crafts[index].scale = craft.scale
            crafts[index].orientation = craft.orientation
        } else {
            dataSource.append(craft: craft)
        }
        dataSource.save()
    }
}
