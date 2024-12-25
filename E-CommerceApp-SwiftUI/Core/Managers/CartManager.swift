import Foundation

// CartItem struct'ı sepetteki her bir ürün için
struct CartItem: Codable, Identifiable {
    let id: Int  // Product ID'si
    let product: Product
    var quantity: Int
    
    // Hesaplanmış özellikler
    var total: Double {
        let discountedPrice = product.price * (1 - product.discountPercentage / 100)
        return discountedPrice * Double(quantity)
    }
}

@MainActor
class CartManager: ObservableObject {
    @Published private(set) var items: [CartItem] = []
    private let cartKey = "savedCart"
    
    static let shared = CartManager()
    
    private init() {
        loadCart()
    }
    
    // Sepete ürün ekleme
    func addToCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            // Ürün zaten sepette varsa miktarını artır
            items[index].quantity += 1
        } else {
            // Yeni ürün ekle
            let cartItem = CartItem(id: product.id, product: product, quantity: 1)
            items.append(cartItem)
        }
        saveCart()
    }
    
    // Sepetten ürün çıkarma
    func removeFromCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.removeAll(where: { $0.id == product.id })
            }
            saveCart()
        }
    }
    
    // Sepetten ürünü tamamen silme
    func removeCompletelyFromCart(_ product: Product) {
        items.removeAll(where: { $0.id == product.id })
        saveCart()
    }
    
    // Sepeti temizleme
    func clearCart() {
        items.removeAll()
        saveCart()
    }
    
    // UserDefaults'a kaydetme
    private func saveCart() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }
    
    // UserDefaults'tan yükleme
    private func loadCart() {
        if let savedData = UserDefaults.standard.data(forKey: cartKey),
           let decodedItems = try? JSONDecoder().decode([CartItem].self, from: savedData) {
            items = decodedItems
        }
    }
    
    // Toplam fiyat hesaplama
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.total }
    }
    
    // Toplam ürün sayısı
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    // Sepette ürün var mı kontrolü
    var isEmpty: Bool {
        items.isEmpty
    }
    
    // Belirli bir ürünün miktarını alma
    func quantity(for product: Product) -> Int {
        items.first(where: { $0.id == product.id })?.quantity ?? 0
    }
    
    // Belirli bir ürünün sepette olup olmadığını kontrol etme
    func isInCart(_ product: Product) -> Bool {
        items.contains(where: { $0.id == product.id })
    }
}