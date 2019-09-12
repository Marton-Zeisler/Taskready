//
//  ToDoListSelectedHeader.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 18..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ToDoListSelectedHeader: BaseTableHeaderFooterView {

    var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "TODAY, OCT 13, 2017", font: UIFont(name: "Lato-Light", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "downIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var sectionIndex: Int?
    
    override func setupViews() {
        backgroundView = mainView
        mainView.addSubview(titleLabel)
        mainView.addSubview(arrowImageView)
        
        titleLabel.setAnchors(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        titleLabel.center(toVertically: self, toHorizontally: nil)
        
        arrowImageView.setAnchors(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 20, bottomConstant: nil)
        arrowImageView.center(toVertically: self, toHorizontally: nil)
        arrowImageView.setAnchorSize(width: 20, height: 20)
    }

}
