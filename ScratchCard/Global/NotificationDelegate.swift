//
//  NotificationDelegate.swift
//  ScratchCard
//
//  Created by Adam Leitgeb on 05.05.23.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Present the notification even when the app is in the foreground
        completionHandler([.banner, .sound, .badge])
    }
}
