import Foundation

enum HomeEndpoints: Endpoints {
    case getCoins(offset: Int)
    case searchCoins(keyword: String)
    
    var baseURL: URL {
        return URL(string: "https://api.coinranking.com")!
    }
    
    var path: String {
        return "/v2/coins"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [:]
    }
    
    var parameters: [String : String] {
        switch self {
        case let .getCoins(offset):
            return ["offset" : "\(offset)", "limit" : "10"]
        case let .searchCoins(keyword):
            return ["search" : keyword]
        }
    }
}
