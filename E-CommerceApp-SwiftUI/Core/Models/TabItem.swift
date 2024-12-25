import Foundation

enum TabItem: Int, CaseIterable {
    case home
    case search
    case cart
    case profile
    
    var title: String {
        switch self {
        case .home: return "Anasayfa"
        case .search: return "Arama"
        case .cart: return "Sepetim"
        case .profile: return "Profil"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .cart: return "cart"
        case .profile: return "person"
        }
    }
}