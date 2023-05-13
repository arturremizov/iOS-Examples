//
//  Asset.swift
//  WidgetsExample
//
//  Created by Artur Remizov on 13.05.23.
//

import Foundation

struct Asset: Decodable {
    let id: String
    let symbol: String
    let name: String
    let priceUsd: String
    
    var price: String {
        let value = Double(priceUsd) ?? 0
        return "$" + String(format: "%.2f", value)
    }
}

struct AssetsContainer<T: Decodable>: Decodable {
    let data: T
}

extension Asset {
    static let previewAsset = Asset(
        id: "bitcoin",
        symbol: "BTC",
        name: "Bitcoin",
        priceUsd: "26908"
    )
}
