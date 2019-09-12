//
//  NSMutableAttributedString+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    public func appendNewLine() {
        append(NSAttributedString(string: "\n"))
    }
    
    public func centerAlign(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        setParagraphStyle(paragraphStyle: paragraphStyle)
    }
    
    public func centerAlignWithSpacing(_ lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = lineSpacing
        setParagraphStyle(paragraphStyle: paragraphStyle)
    }
    
    public func setLineSpacing(_ lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        setParagraphStyle(paragraphStyle: paragraphStyle)
    }
    
    func setParagraphStyle(paragraphStyle: NSParagraphStyle) {
        let range = NSMakeRange(0, string.count)
        addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    }
}
