//
//  UINavigationVC+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 18..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension UINavigationController{
    
    func setupDefaultBarStyle(){
        navigationBar.barStyle = .default
        navigationBar.barTintColor = .white
        navigationBar.tintColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor(r: 70, g: 70, b: 70, a: 1)]
    }
    
}
