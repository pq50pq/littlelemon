import Foundation

enum MenuCategory: String, CaseIterable, Identifiable {
    case starters = "Starters"
    case mains = "Mains"
    case desserts = "Desserts"
    case drinks = "Drinks"

    var id: String { rawValue }
}