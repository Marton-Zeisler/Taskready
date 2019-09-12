//
//  ImageNoteView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 26..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ImageNoteView: BaseView, UITextFieldDelegate {
    
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
        field.returnKeyType = .done
        field.minimumFontSize = 8
        return field
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784865737, blue: 0.8783260584, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ADD IMAGE", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.5508209074, green: 0.5508209074, blue: 0.5508209074, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 40)
        return button
    }()
    
    let closeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeImageIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
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
        addSubview(titleView)
        titleView.addSubview(titleField)
        addSubview(imageView)
        addSubview(addButton)
        addSubview(closeImageButton)
        addSubview(removeButton)
        
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.15)
        titleField.center(toVertically: nil, toHorizontally: titleView)
        titleField.setAnchorSize(to: titleView, widthMultiplier: 0.88, heightMultiplier: 1)
        titleField.delegate = self
        
        addSingleButtonToolbar(textField: titleField, name: "Done", target: self, action: #selector(dismissEditing))
        
        imageView.center(toVertically: self, toHorizontally: nil)
        imageView.setAnchorSize(to: self, widthMultiplier: 1, heightMultiplier: nil)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        
        addButton.setAnchorSize(to: imageView, widthMultiplier: 1, heightMultiplier: 1)
        addButton.center(toVertically: imageView, toHorizontally: nil)
        
        closeImageButton.setAnchors(top: imageView.topAnchor, leading: nil, trailing: imageView.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: nil, trailingConstant: 10, bottomConstant: nil)
        closeImageButton.setAnchorSize(width: 30, height: 30)
        
        removeButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        removeButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.setAnchors(top: removeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    @objc func dismissEditing(){
        endEditing(true)
    }
    
    func loadData(title: String?, image: UIImage?){
        titleField.text = title
        imageView.image = image
    }
    
    func setEditMode(_ isEdit: Bool){
        if isEdit{
            removeButton.isHidden = true
            titleView.isHidden = false
            imageView.isHidden = false
            addButton.isHidden = imageView.image != nil
            closeImageButton.isHidden = imageView.image == nil
        }else{
            removeButton.isHidden = false
            titleView.isHidden = true
            addButton.isHidden = true
            imageView.isHidden = imageView.image == nil
            closeImageButton.isHidden = true
        }
    }
}
