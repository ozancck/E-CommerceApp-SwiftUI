import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductRowView(product: product)
                }
            }
            .navigationTitle("Ürün Ara")
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                Task {
                    await viewModel.searchProducts(query: newValue)
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadAllProducts()
                }
            }
        }
    }
}

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(product.title)
                    .font(.headline)
                Text("₺\(String(format: "%.2f", product.price))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}