//
//  AddNewToDoListView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class AddNewToDoListView: BaseView, UITextFieldDelegate {
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter new list title"
        field.font = UIFont(name: "Lato-Regular", size: 25)
        field.textColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        field.returnKeyType = .continue
        field.minimumFontSize = 8
        return field
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel(text: "COLOR", font: UIFont(name: "Lato-Light", size: 20), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        return collectionView
    }()
    
    let iconLabel: UILabel = {
        let label = UILabel(text: "ICON", font: UIFont(name: "Lato-Light", size: 20), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let iconCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AddNewToDoListIconCell.self, forCellWithReuseIdentifier: "iconCell")
        return collectionView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 18)
        button.setTitleColor(UIColor(r: 210, g: 4, b: 4, a: 1), for: .normal)
        button.backgroundColor = .white
        button.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return button
    }()
    
    override func setupViews() {
        backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        
        addSubview(titleView)
        titleView.addSubview(titleField)
        addSubview(colorLabel)
        addSubview(colorView)
        colorView.addSubview(colorsCollectionView)
        addSubview(iconLabel)
        addSubview(iconView)
        iconView.addSubview(iconCollectionView)
        addSubview(saveButton)
        
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.15)
        titleField.setAnchors(top: titleView.topAnchor, leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor, bottom: titleView.bottomAnchor, topConstant: 0, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0)
        titleField.delegate = self
        addSingleButtonToolbar(textField: titleField, textView: nil, name: "Done", target: self, action: #selector(dismissTextField))

        colorLabel.setAnchors(top: titleView.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        colorView.setAnchors(top: colorLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 8, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        let cellSize = (UIScreen.main.bounds.width - 20 - (10 * 5)) / 6
        colorView.setAnchorSize(width: nil, height: 10+cellSize+20+cellSize+10)
        colorsCollectionView.setAnchors(top: colorView.topAnchor, leading: colorView.leadingAnchor, trailing: colorView.trailingAnchor, bottom: colorView.bottomAnchor, topConstant: 10, leadingConstant: 10, trailingConstant: 10, bottomConstant: 10)

        iconLabel.setAnchors(top: colorView.bottomAnchor, leading: colorLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        iconView.setAnchors(top: iconLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 8, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        iconView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.23)
        iconCollectionView.fillSuperView()

        saveButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        saveButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
    }
    
    @objc func dismissTextField(){
        endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
}
