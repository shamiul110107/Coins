import Foundation
import Combine

enum CoinsData: Equatable {
    case coin(Coin)
    case inviteFriend
}

protocol HomeViewModelProtocol {
    func getCoins(page: Int) async
    func searchCoins(with keyword: String) async
}

class HomeViewModel: HomeViewModelProtocol {
    @Published var coinsData: [CoinsData] = []
    @Published var searchedData: [CoinsData] = []
    @Published var state: State = .normal
    var coinResponse: CoinResponse?
    
    var totalPage = 0
    var topRankCoins: [Coin] = []
    var currentPage = 1
    var inviteFriendPos = 5
    
    let apiService: ApiServiceProtocol
    init(apiService: ApiServiceProtocol = ApiService.shared) {
        self.apiService = apiService
    }
    
    func getCoins(page: Int) async {
        do {
            coinResponse = try await apiService.fetch(with: HomeEndpoints.getCoins(offset: page), type: CoinResponse.self)
            totalPage = coinResponse?.totalPage ?? 0
            coinsData.append(contentsOf: getCoinsWithoutTopRankData(coins: coinResponse?.data?.coins))
            state = .data(coinsData)
        } catch {
            state = .error(error)
        }
    }
    
    func searchCoins(with keyword: String) async {
        // restore the previous data
        if keyword.isEmpty {
            searchedData = coinsData
            state = .data(searchedData)
            return
        }
        do {
            coinResponse = try await apiService.fetch(with: HomeEndpoints.searchCoins(keyword: keyword), type: CoinResponse.self)
            searchedData = generateCoinData(coins: coinResponse?.data?.coins, preDataCount: 0, fromSearch: true)
            state = .data(searchedData)
        } catch {
            state = .error(error)
        }
    }
}

extension HomeViewModel {
    private func generateCoinData(coins: [Coin]?, preDataCount: Int, fromSearch: Bool) -> [CoinsData] {
        guard let coins else {
            return []
        }
        
        var coinsData: [CoinsData] = []
        var start = fromSearch ? 5 : inviteFriendPos
        for (i, coin) in coins.enumerated() {
            if preDataCount + i == start - 1 {
                coinsData.append(.inviteFriend)
                start *= 2
                if !fromSearch {
                    inviteFriendPos = start
                }
            }
            coinsData.append(.coin(coin))
        }
        return coinsData
    }
    
    private func getCoinsWithoutTopRankData(coins: [Coin]?) -> [CoinsData] {
        guard var coins else {
            return []
        }
        topRankCoins = coins.sorted(by: {
            $0.rank ?? 0 < $1.rank ?? 0
        })
        topRankCoins = Array(coins.prefix(3))
        // remove top rank data from all coins
        let uuids = Set(topRankCoins.compactMap { $0.uuid })
        coins = coins.filter { !uuids.contains($0.uuid ?? "") }
        return generateCoinData(coins: coins, preDataCount: coinsData.count, fromSearch: false)
    }
    
    func reset() {
        currentPage = 1
        inviteFriendPos = 5
        searchedData.removeAll()
        coinsData.removeAll()
    }
}
