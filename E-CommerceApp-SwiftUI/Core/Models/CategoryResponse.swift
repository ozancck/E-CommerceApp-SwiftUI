import Foundation

struct Category: Codable {
    let slug: String
    let name: String
    let url: String
}

typealias CategoryResponse = [Category]