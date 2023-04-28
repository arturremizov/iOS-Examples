//
//  NotificationsManager.swift
//  LocalNotificationsWithAsyncAwait
//
//  Created by Artur Remizov on 27.04.23.
//

import UserNotifications

class NotificationsManager: NSObject, ObservableObject {
    
    override init() {
        super.init()
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        setupCoffeeNotificationCategory()
    }
    
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
    
    func createNotification() async throws {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "It is coffee time!"
        notificationContent.subtitle = "Everyday at 10:00 is time to a break."
        notificationContent.body = "Our favorite cafe in Naples is the Napoli Cafe. Try the cappuccino!"
        notificationContent.categoryIdentifier = "COFFEE_TIME"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.hour = 10
        dateComponents.minute = 00
        
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                            repeats: true)
        
        let notificationIdentifier = UUID().uuidString
        
        let notificationRequest = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: notificationContent,
            trigger: calendarTrigger
        )
        
        let notificationCenter = UNUserNotificationCenter.current()
        try await notificationCenter.add(notificationRequest)
    }
    
    func checkPendingNotifications() async {
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationRequests = await notificationCenter.pendingNotificationRequests()
        
        for notificationRequest in notificationRequests {
            print("> \(notificationRequest.identifier)")
        }
    }
    
    func removeNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        
        let notificationIdentifiers = ["weekly-morning-notification"]
        notificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
    }
    
    func setupCoffeeNotificationCategory() {
        let onMyWayAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "On My Way")
        let cantGoAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Can't Go")
        
        let coffeeTimeCategory = UNNotificationCategory(
            identifier: "COFFEE_TIME",
            actions: [onMyWayAction, cantGoAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "Unlock for coffee.",
            options: .customDismissAction
        )
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([coffeeTimeCategory])
    }
}

extension NotificationsManager: UNUserNotificationCenterDelegate {
    
    @MainActor func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
        let actionIdentifier = response.actionIdentifier
        
        print("🟣 Notification Category: \(categoryIdentifier)")
        print("🟣 Action Identifier: \(actionIdentifier)")
    }
}
