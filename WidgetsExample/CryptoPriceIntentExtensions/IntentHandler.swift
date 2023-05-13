//
//  IntentHandler.swift
//  CryptoPriceIntentExtensions
//
//  Created by Artur Remizov on 13.05.23.
//

import Intents

class IntentHandler: INExtension, CryptoPriceConfigurationIntentHandling {
   
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
    func provideSelectedCryptoOptionsCollection(for intent: CryptoPriceConfigurationIntent) async throws -> INObjectCollection<Crypto> {
        let assets = try await AssetFetcher.fetchAssets(limit: 40)
        let cryptos = assets.map { asset in
            let crypto = Crypto(identifier: asset.id, display: "\(asset.name) (\(asset.symbol))")
            crypto.symbol = asset.symbol
            crypto.name = asset.name
            return crypto
        }
        let collection = INObjectCollection(items: cryptos)
        return collection
    }
}
