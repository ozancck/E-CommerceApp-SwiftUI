import Foundation

struct ProductResponse: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?  // Opsiyonel yaptık
    let category: String
    let thumbnail: String
    let images: [String]
    
    // Opsiyonel alanlar
    let tags: [String]?
    let availabilityStatus: String?
}