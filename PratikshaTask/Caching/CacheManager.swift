//
//  CacheManager.swift
//  PratikshaTask
//
//  Created by Pratiksha on 02/07/25.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let fileManager = FileManager.default
    
    private var cacheURL: URL? {
        guard let cacheDirectoryURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cacheDirectoryURLs.appendingPathComponent("holdings.json")
    }
    
    private init() {}
    
    // Save raw data from a network response to a local file
    func saveCache(data: Data) {
        guard let url = cacheURL else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print("Error saving data to cache: \(error.localizedDescription)")
        }
    }
    
    // Load the raw data from local cache file.
    func loadCache() -> Data? {
        guard let cacheURL = cacheURL, fileManager.fileExists(atPath: cacheURL.path) else { return nil }
        
        do {
            return try Data(contentsOf: cacheURL)
        } catch {
            print("Error loading data from cache: \(error.localizedDescription)")
            return nil
        }
    }
}
