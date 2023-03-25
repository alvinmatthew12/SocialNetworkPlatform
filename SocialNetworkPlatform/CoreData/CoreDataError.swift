//
//  CoreDataError.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import Foundation

internal enum CoreDataError: Error {
    case createError
    case fetchError
    case invalidEntityName(name: String)
    case custom(String)
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .createError:
            return NSLocalizedString("Failed to create core data", comment: "Core Data Error")
        case .fetchError:
            return NSLocalizedString("Failed to fetch core data", comment: "Core Data Error")
        case let .invalidEntityName(name):
            return NSLocalizedString("Invalid entity name: \(name)", comment: "Core Data Error")
        case let .custom(message):
            return NSLocalizedString(message, comment: "Core Data Error")
        }
    }
}
