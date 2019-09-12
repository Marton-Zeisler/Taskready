//
//  AddNewToDoListIconCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class AddNewToDoListIconCell: BaseCollectionCell {
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.clipsToBounds = true
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor(r: 212, g: 212, b: 212, a: 1).cgColor
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "toDo_2"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tickImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tickIconGrey"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    
    override func setupViews() {
        backgroundColor = .clear
        
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        addSubview(tickImageView)
        
        circleView.centerWithConstant(toVertically: self, toHorizontally: nil, verticalConstant: -15, horizontatlConstant: nil)
        circleView.setAnchorSize(to: self, widthMultiplier: 1, heightMultiplier: nil)
        circleView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        iconImageView.center(toVertically: circleView, toHorizontally: circleView)
        iconImageView.setAnchorSize(to: circleView, widthMultiplier: nil, heightMultiplier: 0.339933993)
        
        tickImageView.setAnchors(top: circleView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        tickImageView.setAnchorSize(width: 25, height: 25)
        tickImageView.center(toVertically: nil, toHorizontally: self)
        
        setNeedsLayout()
        layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.frame.height / 2
    }
    
    func setData(color: UIColor, iconName: String){
        circleView.backgroundColor = color
        iconImageView.image = UIImage(named: iconName)
    }
    
    func selected(_ selected: Bool){
        if selected{
            circleView.layer.borderWidth = 3
            tickImageView.isHidden = false
        }else{
            circleView.layer.borderWidth = 0
            tickImageView.isHidden = true
        }
    }
}
