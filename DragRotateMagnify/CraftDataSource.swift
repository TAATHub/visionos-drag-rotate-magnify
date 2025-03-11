import SwiftData

final class CraftDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = CraftDataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Craft.self)
        self.modelContext = modelContainer.mainContext
    }

    func append(craft: Craft) {
        modelContext.insert(craft)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchCrafts() -> [Craft] {
        do {
            return try modelContext.fetch(FetchDescriptor<Craft>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func remove(craft: Craft) {
        modelContext.delete(craft)
    }
    
    func save() {
        try? modelContext.save()
    }
}
