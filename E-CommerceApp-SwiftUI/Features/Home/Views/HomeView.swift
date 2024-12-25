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
                        NavigationLink(destination: CategoryProductsView(category: category)) {
                            CategoryCard(category: category)
                        }
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
                    .background(Color.white)
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
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}


private struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        Text(category.name)
            .font(.headline)
            .padding()
            .frame(minWidth: 100)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(10)
    }
}

private struct ProductCard: View {
    let product: Product
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Product Image
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    )
            }
            .frame(width: 160, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product Title
            Text(product.title)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)
                .foregroundColor(.primary)
                .padding(.horizontal, 5)
            
            // Price & Discount
            if product.discountPercentage > 0 {
                HStack {
                    Text("₺\(String(format: "%.2f", product.price))")
                        .strikethrough()
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text("₺\(String(format: "%.2f", product.price * (1 - product.discountPercentage / 100)))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 5)
            } else {
                Text("₺\(String(format: "%.2f", product.price))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 5)
            }
            
            // Add to Cart Button
            Button(action: {
                cartManager.addToCart(product)
            }) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                        .font(.system(size: 14))
                    Text("Sepete Ekle")
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(12)
                .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal, 5)
            .padding(.top, 8)
        }
        .frame(width: 180)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
