import SwiftUI

struct HomeView: View {
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error {
                    VStack {
                        Text("Hata oluştu")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button("Tekrar Dene") {
                            Task {
                                await viewModel.fetchAllData()
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 20) {
                        // Öne Çıkan Ürünler
                        if !viewModel.featuredProducts.isEmpty {
                            FeaturedProductsSection(products: viewModel.featuredProducts)
                        }
                        
                        // Kategoriler
                        if !viewModel.categories.isEmpty {
                            CategoriesSection(categories: viewModel.categories)
                        }
                        
                        // İndirimli Ürünler
                        if !viewModel.discountedProducts.isEmpty {
                            DiscountedProductsSection(products: viewModel.discountedProducts)
                        }
                        
                        // Yeni Ürünler
                        if !viewModel.newProducts.isEmpty {
                            NewProductsSection(products: viewModel.newProducts)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Alışveriş")
            .refreshable {
                await viewModel.fetchAllData()
            }
        }
    }
}

// MARK: - Section Views
private struct FeaturedProductsSection: View {
    let products: [Product]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Öne Çıkanlar")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            FeaturedProductCard(product: product)
                        }
                    }
                }
            }
        }
    }
}

private struct CategoriesSection: View {
    let categories: [Category]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Kategoriler")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.slug) { category in
                        CategoryCard(category: category)
                    }
                }
            }
        }
    }
}

private struct DiscountedProductsSection: View {
    let products: [Product]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("İndirimli Ürünler")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCard(product: product)
                        }
                    }
                }
            }
        }
    }
}

private struct NewProductsSection: View {
    let products: [Product]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Yeni Ürünler")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCard(product: product)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Card Views
private struct FeaturedProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(product.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(product.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text("₺\(String(format: "%.2f", product.price))")
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(width: 200)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

private struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        Text(category.name)
            .font(.headline)
            .padding()
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(10)
    }
}

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
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(product.title)
                .font(.headline)
                .lineLimit(1)
            
            if product.discountPercentage > 0 {
                HStack {
                    Text("₺\(String(format: "%.2f", product.price))")
                        .strikethrough()
                        .foregroundColor(.secondary)
                    
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
                Text("Sepete Ekle")
                    .font(.caption)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .frame(width: 150)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}