//
//  DoggyFetcher.swift
//  DoggyWidgetExtension
//
//  Created by Artur Remizov on 12.05.23.
//

import Foundation
import UIKit

struct Doggy: Decodable {
    let message: URL
    let status: String
}

struct DoggyFetcher {
    
    enum DoggyFetcherError: Error {
        case imageDataCorrupted
    }
    
    private static var cachePath: URL {
        URL.cachesDirectory.appending(path: "doggy.png")
    }
    
    static var cachedDoggy: UIImage? {
        guard let imageData = try? Data(contentsOf: cachePath) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    static var cachedDoggyAvailable: Bool {
        cachedDoggy != nil
    }
    
    static func fetchRandomDoggy() async throws -> UIImage {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let doggy = try JSONDecoder().decode(Doggy.self, from: data)
        let (imageData, _) = try await URLSession.shared.data(from: doggy.message)
        guard let image = UIImage(data: imageData) else {
            throw DoggyFetcherError.imageDataCorrupted
        }
        Task {
            try? await cache(imageData)
        }
        return image
    }
    
    private static func cache(_ imageData: Data) async throws {
        try imageData.write(to: cachePath)
    }
}
