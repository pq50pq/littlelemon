import Foundation

struct MenuList: Decodable {
    let menu: [MenuItemDTO]
}

struct MenuItemDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let price: String
    let image: String?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, price, image, category
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        image = try c.decodeIfPresent(String.self, forKey: .image)
        category = try c.decodeIfPresent(String.self, forKey: .category)
        if let text = try? c.decode(String.self, forKey: .price) {
            price = text
        } else if let number = try? c.decode(Double.self, forKey: .price) {
            price = String(number)
        } else {
            price = "0"
        }
    }
}