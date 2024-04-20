import Foundation
import Combine

enum CoinsData {
    case coin(Coin)
    case inviteFriend
}

protocol HomeViewModelProtocol {
    func getCoins() async
    func searchCoins(with keyword: String) async
}

class HomeViewModel: HomeViewModelProtocol {
    @Published var coinsData: [CoinsData] = []
    var topRankCoins: [Coin] = []
    
    let apiService: ApiServiceProtocol
    init(apiService: ApiServiceProtocol = ApiService.shared) {
        self.apiService = apiService
    }
    
    func getCoins() async {
        do {
            let coinResponse = try await apiService.fetch(with: HomeEndpoints.getCoins, type: CoinResponse.self)
            topRankCoins = getTopRankData(coinResponse: coinResponse)
            coinsData = generateCoinData(coinResponse: coinResponse)
        } catch {
            print(error)
            // handle error here
        }
    }
    
    func searchCoins(with keyword: String) async {
        do {
            let coinResponse = try await apiService.fetch(with: HomeEndpoints.searchCoins(keyword: keyword), type: CoinResponse.self)
            coinsData = generateCoinData(coinResponse: coinResponse)
        } catch {
            // handle error here
        }
    }
    
    private func generateCoinData(coinResponse: CoinResponse) -> [CoinsData] {
        guard let coins = coinResponse.data?.coins else {
            return []
        }
        var coinsData: [CoinsData] = []
        var counter = 5
        for (i, coin) in coins.enumerated() {
            if i == counter {
                coinsData.append(.inviteFriend)
                counter *= 2
            }
            coinsData.append(.coin(coin))
        }
        return coinsData
    }
    
    private func getTopRankData(coinResponse: CoinResponse) -> [Coin] {
        guard var coins = coinResponse.data?.coins else {
            return []
        }
        coins.sort { $0.rank ?? 0 < $1.rank ?? 0 }
        return Array(coins.prefix(3))
    }
}
