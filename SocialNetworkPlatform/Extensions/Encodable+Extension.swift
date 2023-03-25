//
//  Encodable+Extension.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import Foundation

extension Encodable {
    internal func asDictionary() -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        guard
            let data = try? jsonEncoder.encode(self),
            let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap({ $0 as? [String: Any] })
        else {
            return nil
        }
        return dict
    }
}
