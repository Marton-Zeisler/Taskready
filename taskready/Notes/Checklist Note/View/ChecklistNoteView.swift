//
//  ChecklistView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 20..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ChecklistNoteView: BaseView, UITextFieldDelegate {
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter note title"
        field.font = UIFont(name: "Lato-Regular", size: 25)
        field.textColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        field.returnKeyType = .continue
        field.minimumFontSize = 8
        return field
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 18)
        button.setTitleColor(UIColor(r: 210, g: 4, b: 4, a: 1), for: .normal)
        button.backgroundColor = .white
        button.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return button
    }()
    
    let addCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plusIconGrey")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.setTitle("Add checklist item", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 20)
        button.setTitleColor(UIColor(r: 70, g: 70, b: 70, a: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 55
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.1)
        tableView.tableFooterView = UIView()
        tableView.register(ChecklistNoteCell.self, forCellReuseIdentifier: "ChecklistNoteCell")
        tableView.isEditing = true
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = false
        return tableView
    }()
    
    var tableViewTopAnchor: NSLayoutConstraint!
    
    override func setupViews() {
        backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
        addSubview(removeButton)
        addSubview(titleView)
        titleView.addSubview(titleField)
        addSubview(addCheckButton)
        addSubview(tableView)
        
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.15)
        titleField.center(toVertically: nil, toHorizontally: titleView)
        titleField.setAnchorSize(to: titleView, widthMultiplier: 0.88, heightMultiplier: 1)
        titleField.delegate = self
        addSingleButtonToolbar(textField: titleField, name: "Done", target: self, action: #selector(dismissEditing))
        
        addCheckButton.setAnchors(top: titleView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 30, trailingConstant: 20, bottomConstant: nil)
        addCheckButton.setAnchorSize(width: nil, height: 50)
        
        tableView.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: removeButton.topAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10)
        
        removeButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        removeButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.setAnchors(top: removeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    func loadData(checklistNote: ChecklistNote){
        titleField.text = checklistNote.note?.title
    }
    
    @objc func dismissEditing(){
        endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    func setEditMode(_ isEdit: Bool){
        if isEdit{
            removeButton.isHidden = true
            titleView.isHidden = false
            addCheckButton.isHidden = false
            tableView.isEditing = true
            
            tableViewTopAnchor?.isActive = false
            tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: addCheckButton.bottomAnchor, constant: 10)
            tableViewTopAnchor.isActive = true
        }else{
            removeButton.isHidden = false
            titleView.isHidden = true
            addCheckButton.isHidden = true
            tableView.isEditing = false
            
            tableViewTopAnchor?.isActive = false
            tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
            tableViewTopAnchor.isActive = true
        }
    }
    
}
