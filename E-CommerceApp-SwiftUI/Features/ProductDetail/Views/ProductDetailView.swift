import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @StateObject private var cartManager = CartManager.shared
    @State private var selectedImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Ürün Görselleri
                TabView(selection: $selectedImageIndex) {
                    ForEach(product.images.indices, id: \.self) { index in
                        AsyncImage(url: URL(string: product.images[index])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .tag(index)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                VStack(alignment: .leading, spacing: 15) {
                    // Başlık ve Marka
                    HStack {
                        Text(product.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        if let brand = product.brand {
                            Text(brand)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Fiyat ve İndirim
                    HStack {
                        if product.discountPercentage > 0 {
                            Text("₺\(String(format: "%.2f", product.price))")
                                .strikethrough()
                                .foregroundColor(.secondary)
                            
                            Text("₺\(String(format: "%.2f", product.price * (1 - product.discountPercentage/100)))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            Text("%\(Int(product.discountPercentage)) indirim")
                                .font(.caption)
                                .padding(5)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        } else {
                            Text("₺\(String(format: "%.2f", product.price))")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    
                    // Stok Durumu
                    HStack {
                        Image(systemName: product.stock > 0 ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(product.stock > 0 ? .green : .red)
                        Text(product.stock > 0 ? "Stokta var" : "Stokta yok")
                            .font(.subheadline)
                            .foregroundColor(product.stock > 0 ? .green : .red)
                    }
                    
                    Divider()
                    
                    // Ürün Açıklaması
                    Text("Ürün Açıklaması")
                        .font(.headline)
                    Text(product.description)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Ürün Detayları
                    Text("Ürün Detayları")
                        .font(.headline)
                    
                    DetailRow(title: "Kategori", value: product.category)
                    DetailRow(title: "Stok", value: "\(product.stock) adet")
                    DetailRow(title: "Puan", value: String(format: "%.1f", product.rating))
                }
                .padding()
                
                // Sepete Ekleme Butonu
                Button(action: {
                    cartManager.addToCart(product)
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Sepete Ekle")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(product.stock == 0)
                .opacity(product.stock == 0 ? 0.5 : 1)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}