import Foundation

@MainActor
final class ProductListViewModel: ObservableObject {
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var products: [Product] = []
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchProducts() async {
        state = .loading
        do {
            let response: ProductResponse = try await networkManager.fetch(endpoint: .products)
            products = response.products
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func searchProducts(query: String) async {
        state = .loading
        do {
            let response: ProductResponse = try await networkManager.fetch(endpoint: .search(query))
            products = response.products
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}