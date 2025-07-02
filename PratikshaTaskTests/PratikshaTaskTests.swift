//
//  PratikshaTaskTests.swift
//  PratikshaTaskTests
//
//  Created by Pratiksha on 02/07/25.
//

import XCTest
@testable import PratikshaTask

final class PratikshaTaskTests: XCTestCase {
    
    var viewModel: PortfolioViewModel!

    // This method is called before each test runs. It's the perfect place for setup.
    override func setUp() {
        super.setUp()
        viewModel = PortfolioViewModel()
        
        // "mock" data that mimics the real data from the API.
        let mockHoldings = [
            Holding(symbol: "MAHABANK", quantity: 10, ltp: 120.0, avgPrice: 100.0, close: 110.0),
            Holding(symbol: "ICICI", quantity: 5, ltp: 80.0, avgPrice: 100.0, close: 85.0),
            Holding(symbol: "SBI", quantity: 2, ltp: 50.0, avgPrice: 50.0, close: 50.0)
        ]
              
        viewModel = PortfolioViewModel(holdings: mockHoldings)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    func testCurrentValueCalculation() {
        // 1. ARRANGE: The data is already set up in the `setUp` method.
        
        // 2. ACT: Get the calculated value from the view model.
        let calculatedValue = viewModel.currentValue
        
        // 3. ASSERT: Check if the result is what we expect.
        // Expected: (10 * 120) + (5 * 80) + (2 * 50) = 1200 + 400 + 100 = 1700
        XCTAssertEqual(calculatedValue, 1700.0, "Current Value calculation is incorrect")
    }

    // This test verifies the "Total Investment" calculation.
    func testTotalInvestmentCalculation() {
        // Expected: (10 * 100) + (5 * 100) + (2 * 50) = 1000 + 500 + 100 = 1600
        XCTAssertEqual(viewModel.totalInvestment, 1600.0, "Total Investment calculation is incorrect")
    }

    // This test verifies the "Total Profit & Loss" calculation.
    func testTotalPNLCalculation() {
        // Expected: Current Value (1700) - Total Investment (1600) = 100
        XCTAssertEqual(viewModel.totalPNL, 100.0, "Total P&L calculation is incorrect")
    }
    
    // This test verifies the "Today's Profit & Loss" calculation.
    func testTodaysPNLCalculation() {
        // Expected:
        // PROFIT: (120 - 110) * 10 = 100
        // LOSS:   (80 - 85) * 5   = -25
        // SAME:   (50 - 50) * 2   = 0
        // Total: 100 - 25 + 0 = 75
        XCTAssertEqual(viewModel.todaysPNL, -75.0, "Today's P&L calculation is incorrect")
    }
    
    // This test verifies the percentage calculation.
    func testProfitLossPercentageCalculation() {
        // Expected: (Total PNL / Total Investment) * 100 = (100 / 1600) * 100 = 6.25
        XCTAssertEqual(viewModel.profitLossPercentage, 6.25, "Profit Loss Percentage calculation is incorrect")
    }
}
