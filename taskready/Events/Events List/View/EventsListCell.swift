//
//  EventsListCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 28..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class EventsListCell: BaseTableCell {

    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 245, g: 105, b: 134, a: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Music Concert", font: UIFont(name: "Lato-Regular", size: 18), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel(text: "Start at 07:00pm", font: UIFont(name: "Lato-Light", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        return label
    }()
    
    let noteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "greyNoteIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var iconsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noteImageView, locationImageView])
        stack.axis = .horizontal
        stack.alignment = UIStackView.Alignment.trailing
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 15
        return stack
    }()
    
    override func setupViews() {
        let selectionBG = UIView()
        selectionBG.backgroundColor = #colorLiteral(red: 0.9078759518, green: 0.9078759518, blue: 0.9078759518, alpha: 0.2850759846)
        selectedBackgroundView = selectionBG
        addSubview(colorView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(iconsStack)
        
        colorView.setAnchors(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        colorView.setAnchorSize(width: 10, height: 10)
        colorView.center(toVertically: self, toHorizontally: nil)
        
        titleLabel.setAnchors(top: colorView.topAnchor, leading: colorView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: -15, leadingConstant: 10, trailingConstant: 80, bottomConstant: nil)
        detailLabel.setAnchors(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 3, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        
        noteImageView.setAnchorSize(width: 15, height: 15)
        locationImageView.setAnchorSize(width: 15, height: 15)
        
        iconsStack.setAnchors(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 10, bottomConstant: nil)
        iconsStack.center(toVertically: colorView, toHorizontally: nil)
    }
    
    func setupData(event: Event){
        titleLabel.text = event.title
        
        if event.allDay{
            detailLabel.text = "All Day"
        }else{
            let startDate = event.startDate
            let endDate = event.endDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate!)
            
            detailLabel.text = "\(startDateString) - \(endDateString)"
        }
        
        colorView.backgroundColor = UIColor(realmString: event.color)
        locationImageView.isHidden = event.address == nil
        noteImageView.isHidden = event.note == nil
    }

}
