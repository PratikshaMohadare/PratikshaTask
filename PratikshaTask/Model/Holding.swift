//
//  Holding.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import Foundation

// MARK: - HoldingsResponse
struct HoldingsResponse: Codable {
    let data: UserHoldingsResponse
}

struct UserHoldingsResponse: Codable {
    let userHolding: [Holding]
}

// MARK: - Holding
// Represents a single stock holding in the user's portfolio.
// Conforms to Codable to be easily decoded from the JSON API response.
struct Holding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double // Last Traded Price
    let avgPrice: Double
    let close: Double
}

