import Foundation

struct MenuItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let price: String
    let description: String
    let image: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case title, price, description, image, category
    }
}

struct MenuList: Codable {
    let menu: [MenuItem]
}

func fetchMenuData(completion: @escaping ([MenuItem]) -> Void) {
    let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else { return }
        let decoder = JSONDecoder()
        if let decodedMenu = try? decoder.decode(MenuList.self, from: data) {
            DispatchQueue.main.async {
                completion(decodedMenu.menu)
            }
        }
    }.resume()
}