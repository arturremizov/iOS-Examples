//
//  LocalNotificationsWithAsyncAwaitApp.swift
//  LocalNotificationsWithAsyncAwait
//
//  Created by Artur Remizov on 27.04.23.
//

import SwiftUI

@main
struct LocalNotificationsWithAsyncAwaitApp: App {
    
    @StateObject var notificationsManager = NotificationsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationsManager)
        }
    }
}
