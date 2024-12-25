import SwiftUI

struct CategoryProductsView: View {
    let category: Category
    @StateObject private var viewModel = HomeViewModel()
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = error {
                VStack {
                    Text("Hata oluştu")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Button("Tekrar Dene") {
                        Task {
                            await loadProducts()
                        }
                    }
                    .padding()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(products) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(category.name)
        .onAppear {
            Task {
                await loadProducts()
            }
        }
    }
    
    func loadProducts() async {
        isLoading = true
        error = nil
        
        do {
            products = try await viewModel.fetchProductsByCategory(slug: category.slug)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - ProductCard (Kategori sayfası için özel kart tasarımı)
private struct ProductCard: View {
    let product: Product
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if product.discountPercentage > 0 {
                    HStack {
                        Text("₺\(String(format: "%.2f", product.price))")
                            .strikethrough()
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        
                        Text("₺\(String(format: "%.2f", product.price * (1 - product.discountPercentage/100)))")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                } else {
                    Text("₺\(String(format: "%.2f", product.price))")
                        .font(.headline)
                }
                
                Button(action: {
                    cartManager.addToCart(product)
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Sepete Ekle")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}