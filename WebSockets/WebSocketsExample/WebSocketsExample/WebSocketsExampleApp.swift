//
//  WebSocketsExampleApp.swift
//  WebSocketsExample
//
//  Created by Artur Remizov on 25.09.23.
//

import SwiftUI

@main
struct WebSocketsExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(webSocketsManager: URLSessionWebSocketTaskManager())
            )
        }
    }
}
