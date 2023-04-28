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
        VStack(spacing: 24) {
            Button("Request Authorization for Notifications") {
                requestAuthorizationForNotifications()
            }
            Button("Create Notification") {
                createNotification()
            }
            Button("Check Pending Notifications") {
                checkPendingNotifications()
            }
            Button("Remove Notifications") {
                notificationsManager.removeNotifications()
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
    
    private func createNotification() {
        Task {
            do {
                try await notificationsManager.createNotification()
            } catch {
                print("⛔️ \(error.localizedDescription)")
            }
        }
    }
    
    private func checkPendingNotifications() {
        Task {
            await notificationsManager.checkPendingNotifications()
        }
    }
}
