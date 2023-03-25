//
//  Array+Extension.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import Foundation

extension Array {
    @inlinable
    public subscript(safe index: Index) -> Element? {
        get {
            guard startIndex <= index, index < endIndex else { return nil }

            return self[index]
        }
        set {
            guard
                let newValue = newValue,
                startIndex <= index, index < endIndex
            else {
                return
            }

            self[index] = newValue
        }
    }
}
