# E-CommerceApp-SwiftUI 🛍️

A modern e-commerce application developed using SwiftUI with Model-View-ViewModel (MVVM) architecture. The app allows users to view products, search, add items to cart, and complete purchase transactions. The project is developed adopting the modern SwiftUI approach.

![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 🌟 Features

- View and search products by categories
- Detailed product information page
- Shopping cart management
- Add to favorites functionality
- User profile management
- Order history viewing
- Payment simulation with mock service (no real payment integration)
- Dark/Light theme support
- Data caching for offline usage

## 🛠️ Technologies Used

- **SwiftUI**: Modern and declarative UI development
- **Combine**: Reactive programming and data flow management
- **CoreData**: Local data storage and management
- **URLSession**: Network layer for API requests
- **Swift Concurrency**: Asynchronous operations with async/await
- **Swift Package Manager**: Dependency management
- **UserDefaults**: Store user preferences
- **KeychainSwift**: Secure data storage
- **SDWebImageSwiftUI**: Asynchronous image loading and caching
- **swift-collections**: Additional data structures and algorithms

## ⚙️ Installation

1. Clone this repository to your local machine:
```bash
git clone https://github.com/yourusername/E-CommerceApp-SwiftUI.git
```

2. Navigate to the project directory:
```bash
cd E-CommerceApp-SwiftUI
```

3. Open the Xcode project and run.

## 🧪 Testing

The project includes both UI tests and unit tests to ensure code reliability and maintainability.

### Unit Tests
Unit tests validate code units (e.g., ViewModel methods) in isolation. These tests are located in the ECommerceAppTests target.

To run unit tests:
1. Open the Xcode project
2. Select ECommerceAppTests from the target list
3. Press Cmd + U to run unit tests

### UI Tests
UI tests cover core user flows and interactions in the app. These tests are located in the ECommerceAppUITests target.

To run UI tests:
1. Open the Xcode project
2. Select ECommerceAppUITests from the target list
3. Choose a simulator or connected iOS device
4. Press Cmd + U to run UI tests

## 🌐 API

The application uses [DummyJSON](https://dummyjson.com/) API to fetch product data.

## 📱 Screenshots

[Screenshots and screen recording will be added here]

## 📝 License

This project is licensed under the MIT License.
