//
//  ContentView.swift
//  LocalNotificationsWithAsyncAwait
//
//  Created by Artur Remizov on 27.04.23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var notificationsManager: NotificationsManager
    
    var body: some View {
        VStack {
            Button {
                requestAuthorizationForNotifications()
            } label: {
                Text("Request Authorization for Notifications")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NotificationsManager())
    }
}

// MARK: - Methods
extension ContentView {
    
    private func requestAuthorizationForNotifications() {
        Task {
            do {
                try await notificationsManager.requestAuthorizationForNotifications()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
