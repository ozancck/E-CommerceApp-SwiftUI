import SwiftUI

struct MainTabView: View {
    @StateObject private var cartManager = CartManager.shared
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(TabItem.home.title, systemImage: TabItem.home.iconName)
                }
                .tag(TabItem.home)
            
            SearchView()
                .tabItem {
                    Label(TabItem.search.title, systemImage: TabItem.search.iconName)
                }
                .tag(TabItem.search)
            
            CartView()
                .tabItem {
                    Label(TabItem.cart.title, systemImage: TabItem.cart.iconName)
                }
                .tag(TabItem.cart)
                .badge(cartManager.totalItems)
            
            ProfileView()
                .tabItem {
                    Label(TabItem.profile.title, systemImage: TabItem.profile.iconName)
                }
                .tag(TabItem.profile)
        }
    }
}