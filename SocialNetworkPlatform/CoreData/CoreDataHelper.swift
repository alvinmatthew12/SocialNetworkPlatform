//
//  CoreDataHelper.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import Foundation

internal struct CoreDataHelper {
    internal static func setDefaultValue() {
        let manager = CoreDataManager<PostModel>(entityName: "Post")
        let result = manager.fetch()
        switch result {
        case let .success(data):
            if data.isEmpty {
                for post in PostModel.dummy {
                    _ = manager.create(post)
                }
            }
        case .failure:
            break
        }
    }
    
    internal static func getDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        print("Core Data DB Path: \(path ?? "Not found")")
    }
}
