//
//  WebSocketTaskManager.swift
//  WebSocketsExample
//
//  Created by Artur Remizov on 7.11.23.
//

import Foundation
import Combine

enum WebSocketMessage: Hashable {
    case string(String)
    case data(Data)
}

enum WebSocketTaskStatus {
    case open
    case close
}

protocol WebSocketTaskManager {
    var socketTaskStatusPublisher: AnyPublisher<WebSocketTaskStatus, Never> { get }
    var receivedMessagePublisher: AnyPublisher<WebSocketMessage?, Never> { get }
    
    func connectToSocket()
    func disconnect()
    func sendStringMessage(_ message: String)
    func sendDataMessage(_ data: Data)
}
