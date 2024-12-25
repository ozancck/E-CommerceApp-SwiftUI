import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var featuredProducts: [Product] = []
    @Published var categories: [Category] = []
    @Published var discountedProducts: [Product] = []
    @Published var newProducts: [Product] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?

    init() {
        Task {
            await fetchAllData()
        }
    }

    func fetchAllData() async {
        isLoading = true
        error = nil

        do {
            
            try await fetchProducts()

            
            try await fetchCategories()
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func fetchProducts() async throws {
        let products: ProductResponse = try await NetworkManager.shared.fetch(endpoint: .products)

        featuredProducts = Array(products.products.sorted { $0.rating > $1.rating }.prefix(5))

        discountedProducts = Array(products.products.sorted { $0.discountPercentage > $1.discountPercentage }.prefix(5))

        newProducts = Array(products.products.suffix(5))
    }

    func fetchCategories() async throws {
        let categoriesResponse: [Category] = try await NetworkManager.shared.fetch(endpoint: .categories)

        categories = categoriesResponse
    }

    func fetchProductsByCategory(slug: String) async throws -> [Product] {
        let response: ProductResponse = try await NetworkManager.shared.fetch(endpoint: .productsByCategory(slug))
        return response.products
    }
}
