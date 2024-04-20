import Foundation

public typealias HTTPHeaders = [String: String]
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol Endpoints {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: [String : String] { get }
}

extension Endpoints {
    func request() -> URLRequest? {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
