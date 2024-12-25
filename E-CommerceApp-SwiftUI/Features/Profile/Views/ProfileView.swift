import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("Kullanıcı Adı")
                                .font(.headline)
                            Text("kullanici@email.com")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                Section("Hesap") {
                    NavigationLink(destination: EmptyView()) {
                        Label("Siparişlerim", systemImage: "box")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Adreslerim", systemImage: "location")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Ödeme Yöntemlerim", systemImage: "creditcard")
                    }
                }
                
                Section("Ayarlar") {
                    NavigationLink(destination: EmptyView()) {
                        Label("Bildirimler", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Gizlilik", systemImage: "lock")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Yardım", systemImage: "questionmark.circle")
                    }
                }
                
                Section {
                    Button(action: {
                        // Çıkış işlemi
                    }) {
                        Label("Çıkış Yap", systemImage: "arrow.right.square")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}