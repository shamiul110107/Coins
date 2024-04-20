import Foundation

struct CoinResponse: Codable {
    let status: String?
    let data: Data?
}

// MARK: - DataClass
struct Data: Codable {
    let coins: [Coin]?
}

// MARK: - Coin
struct Coin: Codable, Hashable {
    var url: String? {
        let url = iconUrl?.replacingOccurrences(of: ".svg", with: ".png")
        return url
    }
    let uuid, symbol, name: String?
    let iconUrl: String?
    let change: String?
    let price: String?
    let rank: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
