//
//  ToDoListSelectedTaskCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 18..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ToDoListSelectedTaskCell: BaseTableCell {

    let titleLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Regular", size: 17), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Light", size: 13), color: UIColor(r: 136, g: 136, b: 136, a: 1))
        label.isHidden = true
        return label
    }()
    
    lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, timeLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    
    let noteIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noteIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let locationIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var iconsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationIconImageView, noteIconImageView])
        stack.axis = .horizontal
        stack.alignment = UIStackView.Alignment.trailing
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 15
        return stack
    }()
    
    override func setupViews() {
        backgroundColor = .clear
        addSubview(labelsStack)
        addSubview(iconsStack)
        
        labelsStack.setAnchors(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 30, trailingConstant: nil, bottomConstant: nil)
        labelsStack.center(toVertically: self, toHorizontally: nil)
        
        noteIconImageView.setAnchorSize(width: 15, height: 15)
        locationIconImageView.setAnchorSize(width: 15, height: 15)
        iconsStack.setAnchors(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 20, bottomConstant: nil)
        iconsStack.center(toVertically: self, toHorizontally: nil)
        
    }
    
    func setupData(task: Task, otherDays: Bool = false){
        titleLabel.text = task.title
        noteIconImageView.isHidden = task.descr == nil
        locationIconImageView.isHidden = task.locationName == nil
        
        if let dateReminder = task.dateReminder{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = otherDays ? "MMM dd, yyyy 'at' hh:mm a" : "hh:mm a"
            timeLabel.text = dateFormatter.string(from: dateReminder)
            timeLabel.isHidden = false
        }else{
            timeLabel.isHidden = true
        }
    }

}
