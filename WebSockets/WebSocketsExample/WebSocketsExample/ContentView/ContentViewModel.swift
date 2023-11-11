//
//  ContentViewModel.swift
//  WebSocketsExample
//
//  Created by Artur Remizov on 7.11.23.
//

import UIKit
import Combine

class ContentViewModel: ObservableObject {
    
    enum Message: Hashable {
        case string(id: String, string: String)
        case image(id: String, image: UIImage)
        case unknown
        
        init(webSocketMessage: WebSocketMessage?) {
            switch webSocketMessage {
            case .string(let string):
                self = Message.string(id: UUID().uuidString, string: string)
            case .data(let data):
                guard let image = UIImage(data: data) else {
                    self = Message.unknown
                    return
                }
                self = Message.image(id: UUID().uuidString, image: image)
            case .none:
                self = Message.unknown
            }
        }
    }
    
    private let webSocketsManager: WebSocketTaskManager
    private var subscriptions: [AnyCancellable] = []

    @Published private(set) var isConnected: Bool = false
    @Published private(set) var recievedMessages: [ContentViewModel.Message] = []
    @Published var isMessageAlertPresented: Bool = false
    @Published var sendMessageText: String = ""
    
    init(webSocketsManager: WebSocketTaskManager) {
        self.webSocketsManager = webSocketsManager
        binding()
    }
    
    private func binding() {
        webSocketsManager.socketTaskStatusPublisher
            .receive(on: DispatchQueue.main)
            .map { $0 == .open }
            .assign(to: &$isConnected)
        
        webSocketsManager.receivedMessagePublisher
            .receive(on: DispatchQueue.main)
            .map { Message(webSocketMessage: $0) }
            .sink { [weak self] message in
                self?.recievedMessages.append(message)
            }
            .store(in: &subscriptions)
    }
    
    func connect() {
        webSocketsManager.connectToSocket()
    }
    
    func disconnect() {
        webSocketsManager.disconnect()
        recievedMessages = []
    }
    
    func didTapSendStringMessageButton() {
        isMessageAlertPresented = true
    }
    
    func didTapCancelMessageAlertButton() {
        sendMessageText = ""
    }
    
    func didTapSendMessageAlertButton() {
        guard !sendMessageText.isEmpty else { return }
        webSocketsManager.sendStringMessage(sendMessageText)
        sendMessageText = ""
    }
    
    func didTapSendDataMessageButton() {
        /// Example of small chunk of data
        guard let image = UIImage(named: "Small-Data-Image"), let pngData = image.pngData() else { return }
        webSocketsManager.sendDataMessage(pngData)
    }
}
