//
//  WalkthroughCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class WalkthroughCell: BaseCollectionCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Medium", size: 25), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Regular", size: 15), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        imageView.setAnchors(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: titleLabel.topAnchor, topConstant: 50, leadingConstant: 15, trailingConstant: 0, bottomConstant: 60)
        titleLabel.setAnchors(top: nil, leading: nil, trailing: nil, bottom: descriptionLabel.topAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 10)
        titleLabel.center(toVertically: nil, toHorizontally: self)
        titleLabel.setAnchorSize(width: nil, height: 30)
        descriptionLabel.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: nil, leadingConstant: 30, trailingConstant: 30, bottomConstant: 20)
        descriptionLabel.setAnchorSize(width: nil, height: 50)
    }
    
    func setupData(imageName: String, title: String, description: String){
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}
