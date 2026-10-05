import CoreData

@objc(Dish)
public class Dish: NSManagedObject, Identifiable {
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var category: String?
}

extension Dish {
    static func allDishesRequest() -> NSFetchRequest<Dish> {
        NSFetchRequest<Dish>(entityName: "Dish")
    }
}