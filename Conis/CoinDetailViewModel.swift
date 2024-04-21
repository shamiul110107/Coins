import Foundation
protocol CoinDetailViewModelProtocol {
    func getCoinDetails(by uuid: String) async

}

class CoinDetailViewModel: CoinDetailViewModelProtocol {
    @Published var coin: Coin?
    
    let apiService: ApiServiceProtocol
    init(apiService: ApiServiceProtocol = ApiService.shared) {
        self.apiService = apiService
    }
    
    func getCoinDetails(by uuid: String) async {
        do {
            let coinDetails = try await apiService.fetch(with: CoinDetailEndpoints.getCoinDetails(uuid: uuid), type: CoinDetails.self)
            coin = coinDetails.data?.coin
        } catch {
            print(error)
        }
    }
}
