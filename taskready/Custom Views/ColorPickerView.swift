//
//  ColorPickerView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 20..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ColorPickerView: BaseView {

    let colorIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "colorIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Choose Color", font: UIFont(name: "Lato-Regular", size: 20), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "colorUpIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    let seperatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    let colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.isHidden = true
        return collectionView
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addBorder(borderType: .top, width: 0.5, color: UIColor.black.withAlphaComponent(0.2))
        addSubview(colorIconImageView)
        addSubview(titleLabel)
        addSubview(actionButton)
        addSubview(seperatorLineView)
        addSubview(colorsCollectionView)
        
        colorIconImageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        colorIconImageView.setAnchorSize(width: 20, height: 20)
        
        titleLabel.setAnchors(top: nil, leading: colorIconImageView.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        titleLabel.center(toVertically: colorIconImageView, toHorizontally: nil)
        
        actionButton.setAnchors(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 0, bottomConstant: nil)
        actionButton.center(toVertically: colorIconImageView, toHorizontally: nil)
        actionButton.setAnchorSize(width: 60, height: 40)
        
        seperatorLineView.setAnchors(top: colorIconImageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        seperatorLineView.setAnchorSize(width: nil, height: 0.3)
        
        colorsCollectionView.setAnchors(top: seperatorLineView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 8, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    func bringUpColorPicker(){
        UIView.performWithoutAnimation {
            self.actionButton.setImage(UIImage(named: "closeIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButton.layoutIfNeeded()
        }
        
        seperatorLineView.isHidden = false
        colorsCollectionView.isHidden = false
        // smallHeight = 60
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = self.frame.origin.y - (self.frame.height - 60 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
        })
    }
    
    func bringDownColorPicker(){
        UIView.performWithoutAnimation {
            self.actionButton.setImage(UIImage(named: "colorUpIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButton.layoutIfNeeded()
        }
    
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = self.frame.origin.y + (self.frame.height - 60) - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        }) { (_) in
            self.seperatorLineView.isHidden = true
            self.colorsCollectionView.isHidden = true
        }
        
    }

}
