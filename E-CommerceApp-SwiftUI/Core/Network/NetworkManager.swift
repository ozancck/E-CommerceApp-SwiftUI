import Foundation

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch response.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.invalidData
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.invalidResponse
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        case .unauthorized:
            return "Unauthorized"
        }
    }
}