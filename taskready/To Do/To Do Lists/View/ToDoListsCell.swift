//
//  ToDoListsCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ToDoListsCell: BaseCollectionCell {
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
     let titleLabel: UILabel = {
       let label = UILabel(text: "", font: UIFont(name: "Lato-Regular", size: 18), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    let tasksLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Light", size: 14), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    
    lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, tasksLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()
    
    override func setupViews() {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(r: 248, g: 248, b: 248, a: 1)
        selectedBackgroundView = selectedView

        backgroundColor = .white
        
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        addSubview(labelsStack)
        
        circleView.setAnchors(top: topAnchor, leading: nil, trailing: nil, bottom: labelsStack.topAnchor, topConstant: 20, leadingConstant: nil, trailingConstant: nil, bottomConstant: 20)
        circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 1).isActive = true
        circleView.center(toVertically: nil, toHorizontally: self)
        
        iconImageView.setAnchorSize(to: self, widthMultiplier: 0.2, heightMultiplier: 0.2)
        iconImageView.center(toVertically: circleView, toHorizontally: circleView)
        
        titleLabel.setAnchorSize(width: nil, height: 22)
        tasksLabel.setAnchorSize(width: nil, height: 17)
        labelsStack.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: nil, leadingConstant: 20, trailingConstant: 20, bottomConstant: 15)

        setNeedsLayout()
        layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.frame.height/2
    }
    
    
    
    func setupBorders(index: Int){
        if index % 2 == 0{
            addBorder(borderType: .right, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        }

        addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
    }
    
    func setupData(task: TaskList){
        iconImageView.image = UIImage(named: task.icon)
        circleView.backgroundColor = UIColor(realmString: task.color)
        titleLabel.text = task.title
        tasksLabel.text = "\(task.tasks.count) Tasks"
    }
    
}
