import Foundation
enum CoinDetailEndpoints: Endpoints {
    case getCoinDetails(uuid: String)
    
    var baseURL: URL {
        return URL(string: "https://api.coinranking.com")!
    }
    
    var path: String {
        switch self {
        case let .getCoinDetails(uuid):
            return "/v2/coin/" + uuid
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [:]
    }
    
    var parameters: [String : String] {
       return [:]
    }
        
}
