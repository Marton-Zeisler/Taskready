//
//  AddNewToDoListColorCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ColorCell: BaseCollectionCell {
    
    let tickImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tickIcon"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let circleView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setupViews() {
        backgroundColor = .clear
        
        addSubview(circleView)
        circleView.addSubview(tickImageView)
        
        circleView.fillSuperView()
        tickImageView.setAnchorSize(to: circleView, widthMultiplier: nil, heightMultiplier: 0.319018405)
        tickImageView.center(toVertically: circleView, toHorizontally: circleView)
        
        setNeedsLayout()
        layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.frame.height / 2
        
    }
    
    func setColor(color: UIColor){
        circleView.backgroundColor = color
    }
    
}
