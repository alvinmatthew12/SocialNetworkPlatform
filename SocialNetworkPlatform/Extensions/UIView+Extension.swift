//
//  UIView+Extension.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import UIKit

extension UIView {
    public enum ConstraintAttribute {
        case all
        case top, bottom
        case leading, trailing
    }
    
    public func fixInView(_ container: UIView, toSafeArea: Bool = false, attributes: [ConstraintAttribute] = [.all]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        
        let toItem = toSafeArea ? container.safeAreaLayoutGuide : container
        
        if attributes.contains(.top) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        }
        if attributes.contains(.bottom) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
        if attributes.contains(.leading) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        }
        if attributes.contains(.trailing) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: toItem, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        }
    }
}
