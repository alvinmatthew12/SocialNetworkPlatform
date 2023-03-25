//
//  UserManager.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import Foundation

internal final class UserManager {
    internal static let shared = UserManager()
    
    private static let currentUserIDKey = "currentUserID"
    
    private var currentUser: LocalUser?
    
    internal func getCurrentUser() -> LocalUser {
        if let currentUser = currentUser {
            return currentUser
        } else {
            let user = getUserFromUserDefault()
            currentUser = user
            return user
        }
    }
    
    internal func setUserTo(id: Int) {
        guard let user = LocalUser.users.first(where: { $0.id == id }) else { return }
        currentUser = user
        UserDefaults.standard.set(user.id, forKey: UserManager.currentUserIDKey)
    }
    
    private func getUserFromUserDefault() -> LocalUser {
        let currentUserID = UserDefaults.standard.integer(forKey: UserManager.currentUserIDKey)
        if currentUserID != 0, let user = LocalUser.users.first(where: { $0.id == currentUserID }) {
            return user
        } else {
            UserDefaults.standard.set(LocalUser.user1.id, forKey: UserManager.currentUserIDKey)
            return LocalUser.user1
        }
    }
}
