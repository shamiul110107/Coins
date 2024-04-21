//
//  ConisTests.swift
//  ConisTests
//
//  Created by Bismillah on 19/4/2567 BE.
//

import XCTest
@testable import Conis

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockApiService: MockApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiService = MockApiService()
        viewModel = HomeViewModel(apiService: mockApiService)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        mockApiService = nil
    }
    
    func testInitialViewModelData() {
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.coinsData.count, 0)
        XCTAssertEqual(viewModel.inviteFriendPos, 5)
        XCTAssertEqual(viewModel.searchedData.count, 0)
    }
    
    func testGetCoinsSuccess() async throws {
        await viewModel.getCoins(page: 1)
        XCTAssertNotNil(viewModel.coinResponse)
        XCTAssertEqual(viewModel.coinResponse?.data?.coins?.count, 21)
        XCTAssertEqual(viewModel.coinResponse?.data?.stats?.total, 100)
        
        // test fifth element is inviteFriend data
        XCTAssertGreaterThan(viewModel.coinsData.count, 4)
        XCTAssertEqual(viewModel.coinsData[4], .inviteFriend)
    }
    
    func testGetCoinsFailed() async throws {
        mockApiService.shouldFail = true
        await viewModel.getCoins(page: 1)
        XCTAssertNil(viewModel.coinResponse)
        let state = viewModel.state
        guard case .error(let error) = state else {
            XCTFail("State should be error")
            return
        }
        XCTAssertTrue(error is NetworkError)
        XCTAssertEqual(error as? NetworkError, NetworkError.requestFailed)
    }
    
    func testSearchCoinsSuccess() async throws {
        await viewModel.searchCoins(with: "B")
        XCTAssertNotNil(viewModel.coinResponse)
        XCTAssertEqual(viewModel.coinResponse?.data?.coins?.count, 5)
        XCTAssertEqual(viewModel.coinResponse?.data?.stats?.total, 5)
        
        // test fifth element is inviteFriend data
        XCTAssertGreaterThan(viewModel.searchedData.count, 4)
        XCTAssertEqual(viewModel.searchedData[4], .inviteFriend)
    }
}


class MockApiService: ApiServiceProtocol {
    var shouldFail = false
    var willSearch = false
    
    func fetch<T: Decodable>(with endpoints: Endpoints, type: T.Type) async throws -> T {
        if !shouldFail {
            if let coinResponse = loadJson(filename: "coin", type: T.self) as? CoinResponse{
                if case let HomeEndpoints.searchCoins(keyword) = endpoints {
                    return performSearch(response: coinResponse, keyword: keyword) as! T
                }
                return coinResponse as! T
            } else {
                throw NetworkError.responseError
            }
        } else {
            throw NetworkError.requestFailed
        }
    }
    
    func loadJson<T: Decodable>(filename fileName: String, type: T.Type) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(T.self, from: data)
                return response
            } catch {
                print("Unable to parse  \(fileName).json")
            }
        }
        return nil
    }
    
    private func performSearch(response: CoinResponse, keyword: String) -> CoinResponse? {
        var coinResponse = response
        guard let coins = response.data?.coins else {
            return response
        }
        // Filter coins by name containing the keyword
        let filteredCoins = coins.filter { $0.name?.range(of: keyword, options: .caseInsensitive) != nil }
        coinResponse.data?.coins = filteredCoins
        coinResponse.data?.stats?.total = filteredCoins.count
        return coinResponse
    }
}
