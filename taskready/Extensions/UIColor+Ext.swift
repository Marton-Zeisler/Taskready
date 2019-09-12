//
//  UIColor+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    convenience public init(realmString: String){
        let codes = realmString.split(separator: " ")
        if codes.count < 3 {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        let r = CGFloat(Int(codes[0]) ?? 0)
        let g = CGFloat(Int(codes[1]) ?? 0)
        let b = CGFloat(Int(codes[2]) ?? 0)
        
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    func getRealmColorString() -> String?{
        if let components = cgColor.components, components.count >= 3{
            return "\(Int(components[0]*255)) \(Int(components[1]*255)) \(Int(components[2]*255))"
        }else{
            return nil
        }
    }
    
}
