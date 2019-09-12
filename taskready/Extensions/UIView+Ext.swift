//
//  UIView+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

extension UIView{
    
    // ------ BORDER ------
    
    // Border type and arbitrary tag values to identify UIView borders as subviews
    enum BorderType: Int {
        case left = 20000
        case right = 20001
        case top = 20002
        case bottom = 20003
    }
    
    func addBorder(borderType: BorderType, width: CGFloat, color: UIColor) {
        // figure out frame and resizing based on border type
        var autoresizingMask: UIView.AutoresizingMask
        var layerFrame: CGRect
        switch borderType {
        case .left:
            layerFrame = CGRect(x: 0, y: 0, width: width, height: self.bounds.height)
            autoresizingMask = [ .flexibleHeight, .flexibleRightMargin ]
        case .right:
            layerFrame = CGRect(x: self.bounds.width - width, y: 0, width: width, height: self.bounds.height)
            autoresizingMask = [ .flexibleHeight, .flexibleLeftMargin ]
        case .top:
            layerFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: width)
            autoresizingMask = [ .flexibleWidth, .flexibleBottomMargin ]
        case .bottom:
            layerFrame = CGRect(x: 0, y: self.bounds.height - width, width: self.bounds.width, height: width)
            autoresizingMask = [ .flexibleWidth, .flexibleTopMargin ]
        }
        
        // look for the existing border in subviews
        var newView: UIView?
        for eachSubview in self.subviews {
            if eachSubview.tag == borderType.rawValue {
                newView = eachSubview
                break
            }
        }
        
        // set properties on existing view, or create a new one
        if newView == nil {
            newView = UIView(frame: layerFrame)
            newView?.tag = borderType.rawValue
            self.addSubview(newView!)
        } else {
            newView?.frame = layerFrame
        }
        newView?.backgroundColor = color
        newView?.autoresizingMask = autoresizingMask
    }
    
    // ------ ANCHORS -----
    
    func setAnchors(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topConstant: CGFloat?, leadingConstant: CGFloat?, trailingConstant: CGFloat?, bottomConstant: CGFloat?){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top, let topConstant = topConstant{
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let leading = leading, let leadingConstant = leadingConstant{
            leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
        }
        
        if let trailing = trailing, let trailingConstant = trailingConstant{
            trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant).isActive = true
        }
        
        if let bottom = bottom, let bottomConstant = bottomConstant{
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
    }
    
    func setAnchorSize(width: CGFloat?, height: CGFloat?){
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setAnchorSize(to view: UIView, widthMultiplier: CGFloat?, heightMultiplier: CGFloat?)
        
    {
        translatesAutoresizingMaskIntoConstraints = false
        if let widthMultiplier = widthMultiplier{
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier).isActive = true
        }
        
        if let heightMultiplier = heightMultiplier{
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier).isActive = true
        }
    }
    
    func fillSuperView(){
        translatesAutoresizingMaskIntoConstraints = false
        setAnchors(top: superview?.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    func center(toVertically: UIView?, toHorizontally: UIView?){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let toVertically = toVertically{
            centerYAnchor.constraint(equalTo: toVertically.centerYAnchor).isActive = true
        }
        
        if let toHorizontally = toHorizontally{
            centerXAnchor.constraint(equalTo: toHorizontally.centerXAnchor).isActive = true
        }
    }
    
    func centerWithConstant(toVertically: UIView?, toHorizontally: UIView?, verticalConstant: CGFloat?, horizontatlConstant: CGFloat?){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let toVertically = toVertically, let verticalConstant = verticalConstant{
            centerYAnchor.constraint(equalTo: toVertically.centerYAnchor, constant: verticalConstant).isActive = true
        }
        
        if let toHorizontally = toHorizontally, let horizontatlConstant = horizontatlConstant{
            centerXAnchor.constraint(equalTo: toHorizontally.centerXAnchor, constant: horizontatlConstant).isActive = true
        }
    }
    
    // ----- TextInput
    func addSingleButtonToolbar(textField: UITextField? = nil, textView: UITextView? = nil, name: String, target: Any, action: Selector){
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: name, style: .done, target: target, action: action)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        if let textField = textField{
            textField.inputAccessoryView = doneToolbar
        }else if let textView = textView{
            textView.inputAccessoryView = doneToolbar
        }
    }
    
}
