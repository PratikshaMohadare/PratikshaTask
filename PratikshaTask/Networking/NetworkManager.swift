//
//  NetworkManager.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import Foundation

// Defines potential networking errors
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case noData
    case decodingError(Error)
}

enum Endpoints: String {
    case fetchHoldings = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
}

class NetworkManager {
    static let shared = NetworkManager()
    private let urlString = Endpoints.fetchHoldings.rawValue

    private init() {}

    func fetchHoldings(completion: @escaping (Result<[Holding], NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let responseDict = try JSONDecoder().decode(HoldingsResponse.self, from: data)
                let holdings = responseDict.data
                completion(.success(holdings.userHolding))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError)))
            }
        }.resume()
    }
}
