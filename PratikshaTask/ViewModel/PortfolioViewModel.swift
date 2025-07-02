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

    /// Calculates the sum of (LTP * quantity) for all holdings. [cite: 158]
    var currentValue: Double {
        return holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
    }

    /// Calculates the sum of (Average Price * quantity) for all holdings. [cite: 159]
    var totalInvestment: Double {
        return holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
    }

    /// Calculates Today's PNL: sum of ((Close - LTP) * quantity). [cite: 161]
    var todaysPNL: Double {
        return holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
    }

    /// Calculates Total PNL: Current Value - Total Investment. [cite: 160]
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

    // MARK: - Data Fetching
    func fetchUserHoldings(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        NetworkManager.shared.fetchHoldings { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let holdings):
                    self?.holdings = holdings
                    completion(.success(()))
                case .failure(let error):
                    print("Error fetching holdings: \(error.localizedDescription)")
                    self?.holdings = [] // Clear old data on failure
                    completion(.failure(error))
                }
            }
        }
    }

    func getHolding(at index: Int) -> Holding? {
        guard index < holdings.count else { return nil }
        return holdings[index]
    }
}
