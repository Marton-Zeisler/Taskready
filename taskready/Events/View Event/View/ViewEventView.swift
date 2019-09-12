//
//  ViewEventView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ViewEventView: BaseView {
    
    let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Regular", size: 20), color: .white)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let dateIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "greyCalendarIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let fromLabel: UILabel = {
         return  UILabel(text: "From", font: UIFont(name: "Lato-Regular", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let toLabel: UILabel = {
        return UILabel(text: "To", font: UIFont(name: "Lato-Regular", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let fromDateLabel: UILabel = {
        let label = UILabel(text: "22 Oct, 2017 at 08:00 PM", font: UIFont(name: "Lato-Light", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        label.textAlignment = .right
        return label
    }()
    
    let toDateLabel: UILabel = {
        let label = UILabel(text: "22 Oct, 2017 at 08:00 PM", font: UIFont(name: "Lato-Light", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        label.textAlignment = .right
        return label
    }()
    
    let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationLabel: UILabel = {
        return UILabel(text: "Location", font: UIFont(name: "Lato-Regular", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Junior's Restaurant & Bakery, (45th Street), 1515\n Broadway, New York, NY 10019, USA", for: .normal)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 16)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        return button
    }()
    
    let noteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let noteIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noteIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let noteLabel: UILabel = {
        return UILabel(text: "Note", font: UIFont(name: "Lato-Regular", size: 16), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Lato-Light", size: 16)
        textView.textColor = UIColor(r: 44, g: 44, b: 44, a: 1)
        textView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        textView.isEditable = false
        return textView
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 18)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.backgroundColor = .white
        button.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return button
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Medium", size: 18)
        button.setTitleColor(UIColor(r: 210, g: 4, b: 4, a: 1), for: .normal)
        button.backgroundColor = .white
        button.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return button
    }()

    var dateViewHeightConstraint: NSLayoutConstraint?
    var locationTopConstraint: NSLayoutConstraint?
    var noteTopConstraint: NSLayoutConstraint?
    var locationBottomConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        addSubview(editButton)
        addSubview(removeButton)
        
        addSubview(dateView)
        dateView.addSubview(dateIconImageView)
        dateView.addSubview(fromLabel)
        dateView.addSubview(toLabel)
        dateView.addSubview(fromDateLabel)
        dateView.addSubview(toDateLabel)
        
        addSubview(locationView)
        locationView.addSubview(locationLabel)
        locationView.addSubview(locationIcon)
        locationView.addSubview(locationButton)
        
        addSubview(noteView)
        noteView.addSubview(noteLabel)
        noteView.addSubview(noteIcon)
        noteView.addSubview(noteTextView)
        
        
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleLabel.setAnchors(top: titleView.topAnchor, leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor, bottom: titleView.bottomAnchor, topConstant: 8, leadingConstant: 20, trailingConstant: 20, bottomConstant: 20)
        
        
        dateView.setAnchors(top: titleView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        dateViewHeightConstraint = dateView.heightAnchor.constraint(equalToConstant: 100)
        dateViewHeightConstraint?.isActive = true
        dateIconImageView.setAnchors(top: dateView.topAnchor, leading: dateView.leadingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        dateIconImageView.setAnchorSize(width: 20, height: 20)
        fromLabel.center(toVertically: dateIconImageView, toHorizontally: nil)
        fromLabel.setAnchors(top: nil, leading: dateIconImageView.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        fromDateLabel.setAnchors(top: nil, leading: nil, trailing: dateView.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 20, bottomConstant: nil)
        fromDateLabel.center(toVertically: fromLabel, toHorizontally: nil)
        toLabel.setAnchors(top: fromLabel.bottomAnchor, leading: fromLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        toDateLabel.center(toVertically: toLabel, toHorizontally: nil)
        toDateLabel.setAnchors(top: nil, leading: fromDateLabel.leadingAnchor, trailing: fromDateLabel.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        
        locationView.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        locationTopConstraint = locationView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 0)
        locationTopConstraint?.isActive = true
        locationIcon.setAnchors(top: locationView.topAnchor, leading: locationView.leadingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        locationIcon.setAnchorSize(width: 20, height: 20)
        locationLabel.setAnchors(top: nil, leading: locationIcon.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        locationLabel.center(toVertically: locationIcon, toHorizontally: nil)
        locationButton.setAnchors(top: locationLabel.bottomAnchor, leading: locationIcon.leadingAnchor, trailing: locationView.trailingAnchor, bottom: nil, topConstant: 4, leadingConstant: 0, trailingConstant: 20, bottomConstant: nil)
        locationBottomConstraint = locationButton.bottomAnchor.constraint(equalTo: locationView.bottomAnchor, constant: -10)
        
        noteView.setAnchors(top:nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: editButton.topAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 30)
        noteTopConstraint = noteView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 0)
        noteTopConstraint?.isActive = true
        noteIcon.setAnchors(top: noteView.topAnchor, leading: noteView.leadingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        noteIcon.setAnchorSize(width: 20, height: 20)
        noteLabel.setAnchors(top: nil, leading: noteIcon.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        noteLabel.center(toVertically: noteIcon, toHorizontally: nil)
        noteTextView.setAnchors(top: noteLabel.bottomAnchor, leading: noteView.leadingAnchor, trailing: noteView.trailingAnchor, bottom: noteView.bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        
        editButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: removeButton.topAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        editButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        removeButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        removeButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.setAnchors(top: removeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    func setupData(event: Event){
        titleLabel.text = event.title
        titleView.backgroundColor = UIColor(realmString: event.color)
        
        if event.allDay{
            fromLabel.text = "All Day"
            toLabel.isHidden = true
            toDateLabel.isHidden = true
            dateViewHeightConstraint?.isActive = false
            dateViewHeightConstraint?.constant = 50
            dateViewHeightConstraint?.isActive = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            fromDateLabel.text = dateFormatter.string(from: event.startDate)
        }else{
            fromLabel.text = "From"
            toLabel.isHidden = false
            toDateLabel.isHidden = false
            dateViewHeightConstraint?.isActive = false
            dateViewHeightConstraint?.constant = 100
            dateViewHeightConstraint?.isActive = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm a"
            
            fromDateLabel.text = "\(dateFormatter.string(from: event.startDate)) at \(timeFormatter.string(from: event.startDate))"
            toDateLabel.text = "\(dateFormatter.string(from: event.endDate!)) at \(timeFormatter.string(from: event.endDate!))"
        }
        
        if event.placeName == nil && event.note == nil{
            // Hide location and note
            locationView.isHidden = true
            noteView.isHidden = true
        }else if event.placeName != nil && event.note == nil{
            // Show location and hide note
            locationView.isHidden = false
            noteView.isHidden = true
            
            locationTopConstraint?.isActive = false
            locationTopConstraint = locationView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 0)
            locationTopConstraint?.isActive = true
            setLocationButton(placeName: event.placeName!, address: event.address ?? "")
        }else if event.placeName == nil && event.note != nil{
            // Hide location and show note
            noteTextView.text = event.note
            locationView.isHidden = true
            noteView.isHidden = false
            
            noteTopConstraint?.isActive = false
            noteTopConstraint = noteView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 0)
            noteTopConstraint?.isActive = true
        }else if event.placeName != nil && event.note != nil{
            // Show location and note
            setLocationButton(placeName: event.placeName!, address: event.address ?? "")
            noteTextView.text = event.note
            locationView.isHidden = false
            noteView.isHidden = false
            
            locationTopConstraint?.isActive = false
            locationTopConstraint = locationView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 0)
            locationTopConstraint?.isActive = true
            
            noteTopConstraint?.isActive = false
            noteTopConstraint = noteView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 0)
            noteTopConstraint?.isActive = true
            
        }
    }
    
    func setLocationButton(placeName: String, address: String){
        let attributedString = NSMutableAttributedString(string: placeName, attributes: [.font: UIFont(name: "Lato-Light", size: 16)!, .foregroundColor: UIColor(r: 44, g: 44, b: 44, a: 1)])
        attributedString.appendNewLine()
        attributedString.append(NSAttributedString(string: address, attributes: [.font: UIFont(name: "Lato-Light", size: 16)!, .foregroundColor: UIColor(r: 44, g: 44, b: 44, a: 1)]))
        
        UIView.performWithoutAnimation {
            self.locationButton.setAttributedTitle(attributedString, for: .normal)
            self.locationButton.layoutIfNeeded()
        }
        
        locationBottomConstraint?.isActive = false
        locationBottomConstraint = locationButton.bottomAnchor.constraint(equalTo: locationView.bottomAnchor, constant: -20)
        locationBottomConstraint?.isActive = true
        locationButton.layoutIfNeeded()
    }
    

}
