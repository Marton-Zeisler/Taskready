//
//  TextNoteView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 20..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class TextNoteView: BaseView, UITextFieldDelegate, UITextViewDelegate {
    
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
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleView, descriptionTextView])
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fill
        stackView.spacing = 0
        return stackView
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

    override func setupViews() {
        backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
        titleView.addSubview(titleField)
        addSubview(stackView)
        addSubview(removeButton)
    
        titleView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.15)
        titleField.center(toVertically: nil, toHorizontally: titleView)
        titleField.setAnchorSize(to: titleView, widthMultiplier: 0.88, heightMultiplier: 1)
        titleField.delegate = self
        
        addSingleButtonToolbar(textField: titleField, name: "Done", target: self, action: #selector(dismissEditing))
        addSingleButtonToolbar(textView: descriptionTextView, name: "Done", target: self, action: #selector(dismissEditing))
        
        stackView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: removeButton.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10)
        
        descriptionTextView.delegate = self
        
        removeButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        removeButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.setAnchors(top: removeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    @objc func dismissEditing(){
        endEditing(true)
    }
    
    func setEditMode(_ isEdit: Bool){
        if isEdit{
            removeButton.isHidden = true
            titleView.isHidden = false
            descriptionTextView.isEditable = true
            descriptionTextView.isSelectable = true
            if descriptionTextView.text == ""{
                enableTextViewPlaceholder()
            }
        }else{
            removeButton.isHidden = false
            titleView.isHidden = true
            descriptionTextView.isEditable = false
            descriptionTextView.isSelectable = false
            if descriptionTextView.font == UIFont(name: "Lato-Light", size: 18){
                descriptionTextView.text = ""
            }
        }
    }
    
    func loadData(textNote: TextNote){
        titleField.text = textNote.note?.title
        
        if let descr = textNote.descr{
            disableTextViewPlaceholder()
            descriptionTextView.text = descr
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
    func enableTextViewPlaceholder(){
        descriptionTextView.font = UIFont(name: "Lato-Light", size: 18)
        descriptionTextView.text = "Enter description..."
        descriptionTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 0.6)
    }
    
    func disableTextViewPlaceholder(){
        descriptionTextView.font = UIFont(name: "Lato-Regular", size: 18)
        descriptionTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 1)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.font == UIFont(name: "Lato-Light", size: 18){
            descriptionTextView.text = ""
            disableTextViewPlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText{
            enableTextViewPlaceholder()
        }
    }
    
}
