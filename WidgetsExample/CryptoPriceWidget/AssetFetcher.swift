//
//  AssetFetcher.swift
//  WidgetsExample
//
//  Created by Artur Remizov on 13.05.23.
//

import Foundation

struct AssetFetcher {
    
    static func fetchAssets(limit: Int = 10) async throws -> [Asset] {
        let url = URL(string: "https://api.coincap.io/v2/assets?limit=\(limit)")!
        return try await fetchAssets(url)
    }
    
    static func fetchAsset(id: String) async throws -> Asset {
        let url = URL(string: "https://api.coincap.io/v2/assets/\(id)")!
        return try await fetchAssets(url)
    }
    
    private static func fetchAssets<T: Decodable>(_ url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let assetsContainer = try JSONDecoder().decode(AssetsContainer<T>.self, from: data)
        return assetsContainer.data
    }
}
