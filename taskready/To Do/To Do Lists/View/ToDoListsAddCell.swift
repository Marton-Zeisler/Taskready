//
//  ToDoListsAddCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ToDoListsAddCell: BaseCollectionCell {
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 170, g: 170, b: 170, a: 1)
        view.clipsToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "plusIcon"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "ADD NEW", font: UIFont(name: "Lato-Regular", size: 18), color: UIColor(r: 170, g: 170, b: 170, a: 1))
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    
    override func setupViews() {
        let selectedView = UIView()
        selectedView.backgroundColor = .white
        selectedBackgroundView = selectedView
        backgroundColor = UIColor(r: 248, g: 248, b: 248, a: 1)
        
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        addSubview(titleLabel)
        
        circleView.setAnchors(top: topAnchor, leading: nil, trailing: nil, bottom: titleLabel.topAnchor, topConstant: 20, leadingConstant: nil, trailingConstant: nil, bottomConstant: 20)
        circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 1).isActive = true
        circleView.center(toVertically: nil, toHorizontally: self)
        
        iconImageView.setAnchorSize(to: self, widthMultiplier: 0.2, heightMultiplier: 0.2)
        iconImageView.center(toVertically: circleView, toHorizontally: circleView)
        
        titleLabel.setAnchors(top: nil, leading: nil, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 34)
        titleLabel.setAnchorSize(width: nil, height: 22)
        titleLabel.center(toVertically: nil, toHorizontally: self)
        
        setNeedsLayout()
        layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.frame.height/2
    }
    
}
