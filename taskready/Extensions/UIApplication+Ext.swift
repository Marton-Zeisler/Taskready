//
//  UIApplication+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 31..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
    
    class func topNavigation(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {
        
        if let nav = viewController as? UINavigationController {
            return nav
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.navigationController
            }
        }
        return viewController?.navigationController
    }
}
