//
//  Post.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import Foundation

internal struct Post {
    internal let post: String
    internal let postImageName: String?
    internal let user: LocalUser
}

extension Post {
    internal static var dummy: [Post] {
        [
            .init(post: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", postImageName: "post-image-1", user: .user1),
            .init(post: "Good Life", postImageName: nil, user: .user2),
            .init(post: "My New Profile Picture", postImageName: "profile-picture-3", user: .user3),
        ]
    }
}
