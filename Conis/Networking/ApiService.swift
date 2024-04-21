import Foundation

protocol ApiServiceProtocol {
    func fetch<T: Decodable>(with endpoints: Endpoints, type: T.Type) async throws -> T
}

class ApiService {
    static let shared = ApiService()
    private init() { }
}

extension ApiService: ApiServiceProtocol {
    func fetch<T: Decodable>(with endpoints: Endpoints, type: T.Type) async throws -> T {
        guard let request = endpoints.request() else {
            throw NetworkError.invalidURL
        }
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkError.requestFailed
        }
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.responseError
        }
        
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return response
        } catch {
            throw NetworkError.decodingError
        }
    }
}
