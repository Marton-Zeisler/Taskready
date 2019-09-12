//
//  UITabBar+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension UITabBarController{
    
    func createViewController(controller: UIViewController, selectedImage: String, unselectedImage: String) -> UINavigationController{
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.barTintColor = .white
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.titleTextAttributes = [.font: UIFont(name: "Lato-Regular", size: 18)!, .foregroundColor: UIColor(r: 50, g: 50, b: 50, a: 1)]
        navController.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.image = UIImage(named: unselectedImage)?.withRenderingMode(.alwaysOriginal)
        return navController
    }
    
    
}
