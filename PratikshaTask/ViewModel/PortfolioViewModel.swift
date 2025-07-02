//
//  PortfolioViewModel.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import Foundation

class PortfolioViewModel {

    // MARK: - Properties
    private var holdings: [Holding]

    init(holdings: [Holding] = []) {
        self.holdings = holdings
    }

    // MARK: - Calculated Properties (Business Logic)

    // Calculates the sum of (LTP * quantity) for all holdings. [cite: 158]
    var currentValue: Double {
        return holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
    }

    // Calculates the sum of (Average Price * quantity) for all holdings. [cite: 159]
    var totalInvestment: Double {
        return holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
    }

    // Calculates Today's PNL: sum of ((Close - LTP) * quantity). [cite: 161]
    var todaysPNL: Double {
        return holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
    }

    // Calculates Total PNL: Current Value - Total Investment. [cite: 160]
    var totalPNL: Double {
        return currentValue - totalInvestment
    }
    
    var profitLossPercentage: Double {
        guard totalInvestment != 0 else { return 0.0 }
        return (totalPNL / totalInvestment) * 100
    }

    var holdingsCount: Int {
        return holdings.count
    }

    // MARK: - Data Fetching & Caching Logic
        
    /// Fetches holdings with a "cache-first" strategy.
    /// It first attempts to load from the local cache for an instant UI update,
    /// then fetches from the network to get the latest data.
    /// - Parameter completion: A closure that can be called multiple times: once with cached data,
    ///   and again with network data or an error.
    func fetchUserHoldings(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        // Step 1: Attempt to load data from cache
        if let cachedData = CacheManager.shared.loadCache() {
            do {
                let response = try JSONDecoder().decode(HoldingsResponse.self, from: cachedData)
                self.holdings = response.data.userHolding
                // Dispatch to main thread for UI updates
                DispatchQueue.main.async {
                    completion(.success(())) // Update UI with cached data
                }
            } catch {
                print("Failed to decode cached data.")
            }
        }
        
        // Step 2: Fetch from the network to get the latest data
        NetworkManager.shared.fetchHoldings { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let holdings):
                    self?.holdings = holdings
                    completion(.success(()))
                case .failure(let error):
                    // Only pass the error if we don't have any cached data to show.
                    if self?.holdings.isEmpty ?? true {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getHolding(at index: Int) -> Holding? {
        guard index < holdings.count else { return nil }
        return holdings[index]
    }
}
