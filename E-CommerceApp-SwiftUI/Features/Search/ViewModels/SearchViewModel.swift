import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var filteredProducts: [Product] = []
    
    func loadAllProducts() async {
        do {
            let response: ProductResponse = try await NetworkManager.shared.fetch(endpoint: .products)
            filteredProducts = response.products
        } catch {
            print("Error loading products: \(error)")
        }
    }
    
    func searchProducts(query: String) async {
        if query.isEmpty {
            await loadAllProducts()
            return
        }
        
        do {
            let response: ProductResponse = try await NetworkManager.shared.fetch(endpoint: .search(query))
            filteredProducts = response.products
        } catch {
            print("Error searching products: \(error)")
        }
    }
}