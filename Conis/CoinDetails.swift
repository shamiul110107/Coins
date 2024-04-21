import Foundation

struct CoinDetails: Codable {
    let status: String?
    let data: CoinDetailsData?
}

// MARK: - DataClass
struct CoinDetailsData: Codable {
    let coin: Coin?
}

