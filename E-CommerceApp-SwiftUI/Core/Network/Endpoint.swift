import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
}

enum Endpoint {
    case products
    case productsByCategory(String)
    case categories
    case search(String)
}

extension Endpoint: EndpointProtocol {
    var baseURL: String {
        return "https://dummyjson.com"
    }
    
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productsByCategory(let category):
            return "/products/category/\(category)"
        case .categories:
            return "/products/categories"
        case .search(let query):
            return "/products/search?q=\(query)"
        }
    }
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
}