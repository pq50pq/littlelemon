import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct MenuItem: Codable {
    let title: String
    let price: String
}

struct MenuList: Codable {
    let menu: [MenuItem]
}

let urlString = "