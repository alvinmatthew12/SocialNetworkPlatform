//
//  LocalUser.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

internal struct LocalUser {
    internal let id: Int
    internal let name: String
    internal let username: String
    internal let profilePictureName: String
}

extension LocalUser {
    internal static var user1: Self {
        .init(id: 1, name: "Michelle", username: "michelle", profilePictureName: "profile-picture-1")
    }
    
    internal static var user2: Self {
        .init(id: 2, name: "Julian", username: "julian_w", profilePictureName: "profile-picture-2")
    }
    
    internal static var user3: Self {
        .init(id: 3, name: "Olivia", username: "r.olivia11", profilePictureName: "profile-picture-3")
    }
}
