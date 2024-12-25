import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                if cartManager.items.isEmpty {
                    EmptyCartView()
                } else {
                    VStack(spacing: 20) {
                        ForEach(cartManager.items) { item in
                            CartItemView(cartItem: item)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Toplam")
                                .font(.headline)
                            Spacer()
                            Text("₺\(String(format: "%.2f", cartManager.totalPrice))")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding()
                        
                        Button(action: {
                            // Ödeme işlemi
                        }) {
                            Text("Ödemeye Geç")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Sepetim")
            .toolbar {
                if !cartManager.items.isEmpty {
                    Button(action: {
                        cartManager.clearCart()
                    }) {
                        Text("Sepeti Temizle")
                    }
                }
            }
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Sepetiniz Boş")
                .font(.title2)
            
            Text("Alışverişe başlamak için ürünleri keşfedin")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

struct CartItemView: View {
    let cartItem: CartItem
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: cartItem.product.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(cartItem.product.title)
                    .font(.headline)
                
                Text("₺\(String(format: "%.2f", cartItem.product.price))")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                HStack {
                    Button(action: {
                        cartManager.removeFromCart(cartItem.product)
                    }) {
                        Image(systemName: "minus.circle.fill")
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.headline)
                        .frame(width: 30)
                    
                    Button(action: {
                        cartManager.addToCart(cartItem.product)
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("₺\(String(format: "%.2f", cartItem.total))")
                    .font(.headline)
                
                Button(action: {
                    cartManager.removeCompletelyFromCart(cartItem.product)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}