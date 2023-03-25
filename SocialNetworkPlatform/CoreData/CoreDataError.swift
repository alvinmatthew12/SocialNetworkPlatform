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
    case deleteError
    case invalidEntityName(name: String)
    case custom(String)
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .createError:
            return NSLocalizedString("Failed to create data", comment: "Core Data Error")
        case .fetchError:
            return NSLocalizedString("Failed to fetch data", comment: "Core Data Error")
        case .deleteError:
            return NSLocalizedString("Failed to delete data", comment: "Core Data Error")
        case let .invalidEntityName(name):
            return NSLocalizedString("Invalid entity name: \(name)", comment: "Core Data Error")
        case let .custom(message):
            return NSLocalizedString(message, comment: "Core Data Error")
        }
    }
}
