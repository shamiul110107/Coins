import Foundation

enum HomeEndpoints: Endpoints {
    case getCoins
    case searchCoins(keyword: String)
    
    var baseURL: URL {
        return URL(string: "https://api.coinranking.com")!
    }
    
    var path: String {
        switch self {
        case .getCoins:
            return "/v2/coins"
        case let .searchCoins(keyword):
            return "/v2/coins?search=\(keyword)"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [:]
    }
    
    var parameters: [String : String] {
        [:]
    }
}
