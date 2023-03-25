//
//  PostModel.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import Foundation

internal struct PostModel: Codable {
    internal var id: String
    internal var post: String
    internal var postImageName: String?
    internal var userID: Int16
    internal var createdAt: Date
    
    internal var user: LocalUser?
    
    internal enum CodingKeys: String, CodingKey {
        case id, post, postImageName, userID, createdAt
    }
    
    internal init(id: UUID = UUID(), post: String, postImageName: String?, userID: Int, createdAt: Date = Date()) {
        self.id = id.uuidString
        self.post = post
        self.postImageName = postImageName
        self.userID = Int16(userID)
        self.createdAt = createdAt
        
        user = LocalUser.users.first(where: { $0.id == Int(self.userID) })
    }
    
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.post = try container.decode(String.self, forKey: .post)
        if let postImageName = try container.decodeIfPresent(String.self, forKey: .postImageName), postImageName.isEmpty == false {
            self.postImageName = postImageName
        } else {
            self.postImageName = nil
        }
        self.userID = try container.decode(Int16.self, forKey: .userID)
        let createdAtDouble = try container.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: createdAtDouble)
        
        user = LocalUser.users.first(where: { $0.id == Int(self.userID) })
    }
    
    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.post, forKey: .post)
        try container.encode(self.postImageName ?? "", forKey: .postImageName)
        try container.encode(self.userID, forKey: .userID)
        try container.encode(self.createdAt.timeIntervalSince1970, forKey: .createdAt)
    }
}

extension PostModel {
    internal static var dummy: [PostModel] {
        [
            .init(post: "There's something so magical about immersing yourself in nature. It's as if time slows down, and all the worries of the world fade away. Every tree, every flower, every blade of grass has a story to tell - if only we take the time to listen. It reminds us of the power and beauty of the natural world, and the importance of protecting it for generations to come. So take a deep breath, feel the sun on your face, and let the serenity of nature envelop you. It's a reminder that even amidst chaos, there is always beauty and tranquility to be found.", postImageName: "post-image-1", userID: LocalUser.user1.id),
            .init(post: "Living a good life isn't about having everything, but rather appreciating what you do have. It's about finding joy in the little things, being grateful for each day, and surrounding yourself with people who lift you up. It's about prioritizing what matters most and letting go of what doesn't serve you. It's about learning from your mistakes and growing stronger from them. It's about finding balance, living in the present moment, and pursuing your passions with purpose. At the end of the day, a good life is about creating a life you don't need to escape from, but rather one you can embrace with open arms.", postImageName: nil, userID: LocalUser.user2.id),
            .init(post: "My New Profile Picture!", postImageName: "profile-picture-3", userID: LocalUser.user3.id),
        ]
    }
}
