//
//  ContentView.swift
//  WebSocketsExample
//
//  Created by Artur Remizov on 25.09.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel
    init(viewModel: ContentViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !viewModel.isConnected {
                    Button("Connect to Socket") {
                        viewModel.connect()
                    }
                } else {
                    ScrollView {
                        ForEach(viewModel.recievedMessages, id: \.self) {
                            messageCell(message: $0)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("WebSockets")
            .toolbar {
                if viewModel.isConnected {
                    ToolbarItem(placement: .destructiveAction) {
                        disconnectButton
                    }
                    ToolbarItem(placement: .bottomBar) {
                        sendStringMessageButton
                    }
                    ToolbarItem(placement: .bottomBar) {
                        sendDataMessageButton
                    }
                }
            }
            .alert("Enter Message", isPresented: $viewModel.isMessageAlertPresented) {
                TextField("Message...", text: $viewModel.sendMessageText)
                Button("Cancel") {
                    viewModel.didTapCancelMessageAlertButton()
                }
                Button("Send") {
                    viewModel.didTapSendMessageAlertButton()
                }
            }
        }
    }
}

extension ContentView {
    @ViewBuilder
    private func messageCell(message: ContentViewModel.Message) -> some View {
        switch message {
        case .string(_, let string):
            Text(string)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background(Color(uiColor: .secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        case .image(_, let uiimage):
            Image(uiImage: uiimage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .frame(width: 200, height: 200, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .unknown:
            EmptyView()
        }
    }
    
    private var disconnectButton: some View {
        Button(role: .destructive) {
            viewModel.disconnect()
        } label: {
            Text("Disconnect")
                .foregroundStyle(Color.red)
        }
    }
    
    private var sendStringMessageButton: some View {
        Button {
            viewModel.didTapSendStringMessageButton()
        } label: {
            Text("Send string")
        }
    }
    
    private var sendDataMessageButton: some View {
        Button {
            viewModel.didTapSendDataMessageButton()
        } label: {
            Text("Send Data")
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(webSocketsManager: URLSessionWebSocketTaskManager()))
}
