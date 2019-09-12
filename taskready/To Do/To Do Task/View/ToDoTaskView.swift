//
//  ToDoTaskView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 19..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ToDoTaskView: BaseView{
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter task title"
        field.font = UIFont(name: "Lato-Regular", size: 25)
        field.textColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        field.returnKeyType = .continue
        field.minimumFontSize = 8
        return field
    }()
    
    let reminderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .right, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.addBorder(borderType: .bottom, width: 0.8, color: UIColor(r: 245, g: 105, b: 134, a: 1))
        return view
    }()
    
    let reminderButtonIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "redReminderIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let noteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let noteButtonIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "greyNoteIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let clockView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let clockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clockIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let clockLabelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set a reminder", for: .normal)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 16)
        return button
    }()
    
    let clockCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationLabelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set a location", for: .normal)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 16)
        button.titleLabel?.numberOfLines = 2
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let locationCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    let descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.isHidden = true
        return view
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Add some notes"
        textView.textColor = UIColor(r: 44, g: 44, b: 44, a: 0.6)
        textView.font = UIFont(name: "Lato-Light", size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        textView.backgroundColor = .clear
        return textView
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 18)
        button.setTitleColor(UIColor(r: 210, g: 4, b: 4, a: 1), for: .normal)
        button.backgroundColor = .white
        button.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        return textField
    }()
        
    override func setupViews() {
        backgroundColor = UIColor(r: 248, g: 248, b: 248, a: 1)
        addSubview(titleView)
        titleView.addSubview(titleField)
        addSubview(reminderView)
        reminderView.addSubview(reminderButtonIcon)
        addSubview(noteView)
        noteView.addSubview(noteButtonIcon)
        
        addSubview(clockView)
        clockView.addSubview(clockImageView)
        clockView.addSubview(clockLabelButton)
        clockView.addSubview(clockCloseButton)
        
        addSubview(locationView)
        locationView.addSubview(locationImageView)
        locationView.addSubview(locationLabelButton)
        locationView.addSubview(locationCloseButton)
        
        addSubview(descriptionView)
        descriptionView.addSubview(descriptionTextView)
        addSubview(actionButton)
        addSubview(textField)
        
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.15)
        titleField.center(toVertically: nil, toHorizontally: titleView)
        titleField.setAnchorSize(to: titleView, widthMultiplier: 0.88, heightMultiplier: 1)
        addSingleButtonToolbar(textField: titleField, textView: nil, name: "Done", target: self, action: #selector(dismissTexts))
        
        reminderView.setAnchors(top: titleView.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        reminderView.setAnchorSize(to: self, widthMultiplier: 0.5, heightMultiplier: 0.1)
        reminderButtonIcon.fillSuperView()
        reminderButtonIcon.addTarget(self, action: #selector(reminderIconTapped), for: .touchUpInside)
        
        noteView.setAnchors(top: titleView.bottomAnchor, leading: reminderView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        noteView.setAnchorSize(to: reminderView, widthMultiplier: nil, heightMultiplier: 1)
        noteButtonIcon.fillSuperView()
        noteButtonIcon.addTarget(self, action: #selector(noteIconTapped), for: .touchUpInside)
        
        clockView.setAnchors(top: reminderView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        clockView.setAnchorSize(to: reminderView, widthMultiplier: nil, heightMultiplier: 0.9)
        clockImageView.setAnchors(top: nil, leading: clockView.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        clockImageView.setAnchorSize(to: clockView, widthMultiplier: nil, heightMultiplier: 0.3)
        clockImageView.widthAnchor.constraint(equalTo: clockImageView.heightAnchor, multiplier: 1).isActive = true
        clockImageView.center(toVertically: clockView, toHorizontally: nil)
        clockLabelButton.setAnchors(top: nil, leading: clockImageView.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        clockLabelButton.center(toVertically: clockView, toHorizontally: nil)
        clockCloseButton.setAnchors(top: clockView.topAnchor, leading: nil, trailing: clockView.trailingAnchor, bottom: clockView.bottomAnchor, topConstant: 0, leadingConstant: nil, trailingConstant: 0, bottomConstant: 0)
        clockCloseButton.widthAnchor.constraint(equalTo: clockView.heightAnchor, multiplier: 1).isActive = true
        
        locationView.setAnchors(top: clockView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        locationView.heightAnchor.constraint(equalTo: reminderView.heightAnchor, multiplier: 0.9)
        locationImageView.setAnchorSize(to: locationView, widthMultiplier: nil, heightMultiplier: 0.3)
        locationImageView.widthAnchor.constraint(equalTo: locationImageView.heightAnchor, multiplier: 1).isActive = true
        locationImageView.center(toVertically: locationView, toHorizontally: nil)
        locationImageView.center(toVertically: nil, toHorizontally: clockImageView)
        locationImageView.setAnchors(top: nil, leading: locationView.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        locationLabelButton.setAnchors(top: nil, leading: clockLabelButton.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        locationLabelButton.setAnchorSize(to: locationView, widthMultiplier: 0.7, heightMultiplier: 1)
        locationCloseButton.setAnchors(top: locationView.topAnchor, leading: nil, trailing: locationView.trailingAnchor, bottom: locationView.bottomAnchor, topConstant: 0, leadingConstant: nil, trailingConstant: 0, bottomConstant: 0)
        locationCloseButton.center(toVertically: nil, toHorizontally: clockCloseButton)
        locationCloseButton.widthAnchor.constraint(equalTo: locationView.heightAnchor, multiplier: 1).isActive = true
        
        descriptionView.setAnchors(top: noteView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        
        descriptionView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.3)
        descriptionTextView.fillSuperView()
        addSingleButtonToolbar(textView: descriptionTextView, name: "Done", target: self, action: #selector(dismissTexts))
        
        actionButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        actionButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.setAnchors(top: actionButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    @objc func dismissTexts(){
        endEditing(true)
    }
    
    @objc func reminderIconTapped(){
        reminderButtonIcon.setImage(UIImage(named: "redReminderIcon"), for: .normal)
        reminderView.addBorder(borderType: .bottom, width: 0.8, color: UIColor(r: 245, g: 105, b: 134, a: 1))
        
        noteButtonIcon.setImage(UIImage(named: "greyNoteIcon"), for: .normal)
        noteView.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        
        clockView.isHidden = false
        locationView.isHidden = false
        descriptionView.isHidden = true
    }
    
    @objc func noteIconTapped(){
        noteButtonIcon.setImage(UIImage(named: "redNoteIcon"), for: .normal)
        noteView.addBorder(borderType: .bottom, width: 0.8, color: UIColor(r: 245, g: 105, b: 134, a: 1))
        
        reminderButtonIcon.setImage(UIImage(named: "greyReminderIcon"), for: .normal)
        reminderView.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        
        clockView.isHidden = true
        locationView.isHidden = true
        descriptionView.isHidden = false
    }
    
    func setClockLabel(date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        clockLabelButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        clockCloseButton.isHidden = false
        UIView.performWithoutAnimation {
            clockLabelButton.setTitle(dateFormatter.string(from: date), for: .normal)
            clockLabelButton.layoutIfNeeded()
        }
    }
    
    func removeClockLabel(){
        clockLabelButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 16)
        clockCloseButton.isHidden = true
        UIView.performWithoutAnimation {
            clockLabelButton.setTitle("Set a reminder", for: .normal)
            clockLabelButton.layoutIfNeeded()
        }
    }
    
    func setLocationLabel(name: String, address: String){
        let attributedString = NSMutableAttributedString(string: name, attributes: [.font: UIFont(name: "Lato-Regular", size: 16) ?? UIFont.systemFont(ofSize: 14)])
        attributedString.appendNewLine()
        attributedString.append(NSAttributedString(string: address, attributes: [.font : UIFont(name: "Lato-Light", size: 14) ?? UIFont.systemFont(ofSize: 14)]))
        
        locationCloseButton.isHidden = false
        
        UIView.performWithoutAnimation {
            locationLabelButton.setAttributedTitle(attributedString, for: .normal)
            locationLabelButton.layoutIfNeeded()
        }
    }
    
    func hideLocationLabel(){
        locationLabelButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 16)
        locationCloseButton.isHidden = true
        let attributedString = NSAttributedString(string: "Set a location", attributes: [.font : UIFont(name: "Lato-Light", size: 16) ?? UIFont.systemFont(ofSize: 14)])
        UIView.performWithoutAnimation {
            locationLabelButton.setAttributedTitle(attributedString, for: .normal)
            locationLabelButton.layoutIfNeeded()
        }
    }
    
    func setNoteText(_ text: String){
        descriptionTextView.text = text
        descriptionTextView.font = UIFont(name: "Lato-Regular", size: 18)
        descriptionTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 1)
    }
    
    func setActionButtonSave(){
        actionButton.setTitleColor(UIColor(r: 210, g: 4, b: 4, a: 1), for: .normal)
        UIView.performWithoutAnimation {
            actionButton.setTitle("Save", for: .normal)
        }
    }
    
    func setActionButtonComplete(){
        actionButton.setTitleColor(UIColor(r: 16, g: 154, b: 43, a: 1), for: .normal)
        UIView.performWithoutAnimation {
            actionButton.setTitle("Complete", for: .normal)
        }
    }
    
    func enableTextViewPlaceholder(){
        descriptionTextView.font = UIFont(name: "Lato-Light", size: 18)
        descriptionTextView.text = "Add some notes"
        descriptionTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 0.6)
    }
    
    func disableTextViewPlaceholder(){
        descriptionTextView.text = ""
        descriptionTextView.font = UIFont(name: "Lato-Regular", size: 18)
        descriptionTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 1)
    }

}

