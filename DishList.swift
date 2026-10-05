import SwiftUI
import CoreData

struct DishList: View {
    @FetchRequest private var dishes: FetchedResults<Dish>
    private let onSelect: (Dish) -> Void

    init(search: String, category: MenuCategory?, onSelect: @escaping (Dish) -> Void) {
        var predicates: [NSPredicate] = []

        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", trimmed))
        }
        if let category = category {
            predicates.append(NSPredicate(format: "category ==[cd] %@", category.rawValue))
        }
        let predicate = predicates.isEmpty
            ? NSPredicate(value: true)
            : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        let sort = NSSortDescriptor(key: "title",
                                    ascending: true,
                                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))

        _dishes = FetchRequest(sortDescriptors: [sort], predicate: predicate)
        self.onSelect = onSelect
    }

    var body: some View {
        List(dishes) { dish in
            Button {
                onSelect(dish)
            } label: {
                DishRow(dish: dish)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
        .overlay {
            if dishes.isEmpty {
                Text("No dishes found.").foregroundColor(.secondary)
            }
        }
    }
}