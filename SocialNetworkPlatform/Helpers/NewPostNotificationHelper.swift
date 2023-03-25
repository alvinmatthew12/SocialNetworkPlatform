//
//  NewPostNotificationHelper.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal struct NewPostNotificationHelper {
    private static let name = Notification.Name("NewPostNotification")
    
    internal static func observe(didAddNewPost: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: NewPostNotificationHelper.name, object: nil, queue: nil, using: didAddNewPost)
    }
    
    internal static func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NewPostNotificationHelper.name, object: nil)
    }
    
    internal static func post() {
        NotificationCenter.default.post(Notification(name: NewPostNotificationHelper.name))
    }
}
