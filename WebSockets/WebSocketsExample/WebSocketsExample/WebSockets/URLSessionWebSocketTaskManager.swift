//
//  URLSessionWebSocketTaskManager.swift
//  WebSocketsExample
//
//  Created by Artur Remizov on 25.09.23.
//

import Foundation
import UIKit
import Combine

final class URLSessionWebSocketTaskManager: NSObject, WebSocketTaskManager {
    
    var socketTaskStatusPublisher: AnyPublisher<WebSocketTaskStatus, Never> {
        $socketTaskStatus.eraseToAnyPublisher()
    }
    var receivedMessagePublisher: AnyPublisher<WebSocketMessage?, Never> {
        $receivedMessage.eraseToAnyPublisher()
    }
    
    private let url: URL
    private var socketTask:  URLSessionWebSocketTask?
    @Published private var socketTaskStatus: WebSocketTaskStatus = .close
    @Published private var receivedMessage: WebSocketMessage? = nil

    init(url: URL = URL(string: "ws://localhost:8080")!) {
        self.url = url
        super.init()
    }
    
    func connectToSocket() {
        socketTask = URLSession.shared.webSocketTask(with: url)
        socketTask?.delegate = self
        socketTask?.resume()
    }
    
    func disconnect() {
        disconnect(with: .goingAway)
    }
    
    func sendStringMessage(_ message: String) {
        send(URLSessionWebSocketTask.Message.string(message))
    }
    
    func sendDataMessage(_ data: Data) {
        send(URLSessionWebSocketTask.Message.data(data))
    }
    
    private func sendPing() {
        socketTask?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Sending PING failed: \(error)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.sendPing()
            }
        })
    }
    
    // MARK: - Helpers
    private func disconnect(with status: URLSessionWebSocketTask.CloseCode = .goingAway) {
        socketTask?.cancel(with: status, reason: nil)
        socketTask = nil
        socketTaskStatus = .close
    }
    
    private func setReceiveHandler() {
        socketTask?.receive { [weak self] result in
            guard let self else { return }
            do {
                let message = try result.get()
                switch message {
                case let .string(string):
                    receivedMessage = .string(string)
                case let .data(data):
                    receivedMessage = .data(data)
                @unknown default:
                    print("Unkown message received")
                    receivedMessage = nil
                }
                self.setReceiveHandler()
            } catch {
                let nsError = error as NSError
                print(error)
                if nsError.domain == NSPOSIXErrorDomain, nsError.code == 57 {
                    // Socket is not connected, disconnect
                    self.disconnect(with: .invalid)
                } else {
                    self.setReceiveHandler()
                }
            }
        }
    }
    
    private func send(_ message: URLSessionWebSocketTask.Message) {
        socketTask?.send(message) { error in
            if let error {
                print("Failed to send message. \(error)")
            }
        }
    }
}

// MARK: - URLSessionTaskDelegate
extension URLSessionWebSocketTaskManager: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Task: \(task), didCompleteWithError: \(String(describing: error))")
    }
}

// MARK: - URLSessionWebSocketDelegate
extension URLSessionWebSocketTaskManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
       print("WebSocketTask did open. WebSocketTask = \(webSocketTask)")
        socketTaskStatus = .open
        setReceiveHandler()
        sendPing()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocketTask did close.  WebSocketTask = \(webSocketTask), close code: \(closeCode)")
        socketTaskStatus = .close
    }
}
