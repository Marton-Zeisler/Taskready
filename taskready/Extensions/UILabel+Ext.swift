//
//  UILabel+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension UILabel{
    
    convenience init(text: String, font: UIFont?, color: UIColor){
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = color
    }
    
}
