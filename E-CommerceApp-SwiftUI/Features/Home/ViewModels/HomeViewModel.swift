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
            // Önce ürünleri yükle
            try await fetchProducts()
            
            // Sonra kategorileri yükle
            try await fetchCategories()
        } catch {
            print("❌ Hata: \(error.localizedDescription)")
            self.error = error
        }
        
        isLoading = false
    }
    
    func fetchProducts() async throws {
        let products: ProductResponse = try await NetworkManager.shared.fetch(endpoint: .products)
        print("📦 Toplam ürün sayısı: \(products.products.count)")
        
        // Öne çıkan ürünler - En yüksek puanlı 5 ürün
        featuredProducts = Array(products.products.sorted { $0.rating > $1.rating }.prefix(5))
        print("⭐️ Öne çıkan ürün sayısı: \(featuredProducts.count)")
        
        // İndirimli ürünler - En yüksek indirim oranına sahip 5 ürün
        discountedProducts = Array(products.products.sorted { $0.discountPercentage > $1.discountPercentage }.prefix(5))
        print("💰 İndirimli ürün sayısı: \(discountedProducts.count)")
        
        // Yeni ürünler - Son 5 ürün
        newProducts = Array(products.products.suffix(5))
        print("🆕 Yeni ürün sayısı: \(newProducts.count)")
    }
    
    func fetchCategories() async throws {
        let categoriesResponse: [Category] = try await NetworkManager.shared.fetch(endpoint: .categories)
        print("🏷 Kategori sayısı: \(categoriesResponse.count)")
        categories = categoriesResponse
    }
}