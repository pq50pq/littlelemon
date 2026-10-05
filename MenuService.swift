import Foundation
import CoreData

enum MenuServiceError: LocalizedError {
    case badURL
    case badResponse

    var errorDescription: String? {
        switch self {
        case .badURL: return "The menu address is invalid."
        case .badResponse: return "The server returned an unexpected response."
        }
    }
}

enum MenuService {
    static let menuURL = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"

    static func fetchMenu() async throws -> [MenuItemDTO] {
        guard let url = URL(string: menuURL) else { throw MenuServiceError.badURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw MenuServiceError.badResponse
        }
        return try JSONDecoder().decode(MenuList.self, from: data).menu
    }

    @MainActor
    static func save(_ items: [MenuItemDTO], in context: NSManagedObjectContext) throws {
        let existing = try context.fetch(Dish.allDishesRequest())
        var byID = Dictionary(existing.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })

        for item in items {
            let key = Int32(item.id)
            let dish: Dish
            if let found = byID[key] {
                dish = found
                byID[key] = nil
            } else {
                dish = NSEntityDescription.insertNewObject(forEntityName: "Dish", into: context) as! Dish
                dish.id = key
            }
            dish.title = item.title
            dish.descriptionText = item.description
            dish.price = item.price
            dish.image = item.image
            dish.category = item.category
        }

        byID.values.forEach { context.delete($0) }

        if context.hasChanges { try context.save() }
    }

    @MainActor
    static func refresh(in context: NSManagedObjectContext) async throws {
        let items = try await fetchMenu()
        try save(items, in: context)
    }
}