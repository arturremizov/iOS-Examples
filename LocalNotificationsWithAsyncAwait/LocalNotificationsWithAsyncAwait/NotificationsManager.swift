//
//  NotificationsManager.swift
//  LocalNotificationsWithAsyncAwait
//
//  Created by Artur Remizov on 27.04.23.
//

import UserNotifications

class NotificationsManager: ObservableObject {
    
    @discardableResult
    func requestAuthorizationForNotifications() async throws -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        let authorizationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        do {
            let isAuthorizationGranted = try await notificationCenter.requestAuthorization(options: authorizationOptions)
            return isAuthorizationGranted
        } catch {
            throw error
        }
    }
    
    func checkCurrentAuthorizationSetting() async -> UNNotificationSettings {
        let notificationCenter = UNUserNotificationCenter.current()
        let currentSettings = await notificationCenter.notificationSettings()
        return currentSettings
    }
}
