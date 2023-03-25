//
//  UIApplication+Extension.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//


import UIKit

extension UIApplication {
    public class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

