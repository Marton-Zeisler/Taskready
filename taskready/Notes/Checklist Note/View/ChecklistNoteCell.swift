//
//  ChecklistNoteCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 20..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ChecklistNoteCell: BaseTableCell, UITextFieldDelegate {
    
    let checkBoxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "checkboxOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.placeholder = "Item title"
        field.textColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        field.font = UIFont(name: "Lato-Light", size: 18)
        field.returnKeyType = .done
        return field
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(checkBoxButton)
        addSubview(titleField)
        
        checkBoxButton.setAnchors(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 55, trailingConstant: nil, bottomConstant: nil)
        checkBoxButton.setAnchorSize(width: 25, height: 25)
        checkBoxButton.center(toVertically: self, toHorizontally: nil)
        
        titleField.setAnchors(top: nil, leading: checkBoxButton.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: 55, bottomConstant: nil)
        titleField.center(toVertically: self, toHorizontally: nil)
        titleField.delegate = self
        addSingleButtonToolbar(textField: titleField, textView: nil, name: "Done", target: self, action: #selector(dismissField))
    }
    
    @objc func dismissField() {
        endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func setEditMode(editing: Bool){
        titleField.isUserInteractionEnabled = editing
    }
    
    func setupData(item: ChecklistItem){
        titleField.text = item.title
        
        if item.completed{
            UIView.performWithoutAnimation {
                self.checkBoxButton.setImage(UIImage(named: "checkboxOn")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.checkBoxButton.layoutIfNeeded()
            }
        }else{
            UIView.performWithoutAnimation {
                self.checkBoxButton.setImage(UIImage(named: "checkboxOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.checkBoxButton.layoutIfNeeded()
            }
        }
    }
    
    
}
