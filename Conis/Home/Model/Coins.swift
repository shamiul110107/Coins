import Foundation

struct CoinResponse: Codable {
    let status: String?
    var data: Data?
    var totalPage: Int {
        let totalItems = data?.stats?.total ?? 0
        let itemsPerPage = 10
        return Int(ceil(Double(totalItems) / Double(itemsPerPage)))
    }
}

// MARK: - DataClass
struct Data: Codable {
    var stats: Stats?
    var coins: [Coin]?
}

// MARK: - Coin
struct Coin: Codable, Hashable {
    var url: String? {
        let url = iconUrl?.replacingOccurrences(of: ".svg", with: ".png")
        return url
    }
    let uuid, symbol, name, description: String?
    let iconUrl: String?
    let change: String?
    let price: String?
    let rank: Int?
    let color: String?
    let websiteUrl: String?
    let marketCap: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Stats: Codable {
    var total: Int?
}
