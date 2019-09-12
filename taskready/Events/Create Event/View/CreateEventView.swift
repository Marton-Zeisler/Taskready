//
//  CreateEventView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 02..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class CreateEventView: BaseView {

    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let addTitleLabel: UILabel = {
        return UILabel(text: "Add Title", font: UIFont(name: "Lato-Light", size: 14), color: UIColor(r: 70, g: 70, b: 70, a: 1))
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.placeholder = "Title"
        textField.font = UIFont(name: "Lato-Regular", size: 18)
        textField.borderStyle = .none
        return textField
    }()
    
    let titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel(text: "Start Date", font: UIFont(name: "Lato-Light", size: 14), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        label.textAlignment = .center
        return label
    }()
    
    let startDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let startDateSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var startDateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startDateLabel, startDateButton])
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.center
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    lazy var fullStartDateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startDateStack, startDateSeparator])
        stack.axis = .horizontal
        stack.alignment = UIStackView.Alignment.fill
        stack.distribution = UIStackView.Distribution.fill
        stack.spacing = 20
        return stack
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel(text: "Start Time", font: UIFont(name: "Lato-Light", size: 14), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        label.textAlignment = .center
        return label
    }()
    
    let startTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let startTimeSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var startTimeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startTimeLabel, startTimeButton])
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.center
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    lazy var fullStartTimeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [startTimeStack, startTimeSeparator])
        stack.axis = .horizontal
        stack.alignment = UIStackView.Alignment.center
        stack.distribution = UIStackView.Distribution.fill
        stack.spacing = 20
        return stack
    }()
    
    let endTimeLabel: UILabel = {
        let label = UILabel(text: "End Time", font: UIFont(name: "Lato-Light", size: 14), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        return label
    }()
    
    let endTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        return button
    }()
    
    lazy var endTimeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [endTimeLabel, endTimeButton])
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.center
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    lazy var completeDateTimeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullStartDateStack, fullStartTimeStack, endTimeStack])
        stack.alignment = UIStackView.Alignment.leading
        stack.distribution = UIStackView.Distribution.fillEqually
        return stack
    }()
    
    let completeDateTimeSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    let allDayCheckButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ALL DAY", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 17)
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.setImage(UIImage(named: "smallCheckboxOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let locationLabel: UILabel = {
        return UILabel(text: "LOCATION", font: UIFont(name: "Lato-Regular", size: 17), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "locationIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set a location", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(UIColor(r: 44, g: 44, b: 44, a: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let locationCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    
    let noteLabel: UILabel = {
        return UILabel(text: "NOTE", font: UIFont(name: "Lato-Regular", size: 17), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let noteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noteIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let noteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Add some notes"
        textView.textColor = UIColor(r: 44, g: 44, b: 44, a: 0.6)
        textView.font = UIFont(name: "Lato-Light", size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return textView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        return textField
    }()
    
    override func setupViews() {
        backgroundColor = UIColor(r: 248, g: 248, b: 248, a: 1)
        
        addSubview(titleView)
        titleView.addSubview(addTitleLabel)
        titleView.addSubview(titleTextField)
        addSubview(titleSeparator)
        
        addSubview(dateView)
        dateView.addSubview(completeDateTimeStack)
        addSubview(completeDateTimeSeparator)
        
        addSubview(allDayCheckButton)
        addSubview(locationLabel)
        addSubview(locationImageView)
        addSubview(locationView)
        locationView.addSubview(locationButton)
        locationView.addSubview(locationCloseButton)
        
        addSubview(noteLabel)
        addSubview(noteImageView)
        addSubview(noteView)
        noteView.addSubview(noteTextView)
        
        addSubview(textField)
        
        // Title field
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleView.setAnchorSize(width: nil, height: 80)
        addTitleLabel.setAnchors(top: titleView.topAnchor, leading: titleView.leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        titleTextField.setAnchors(top: addTitleLabel.bottomAnchor, leading: addTitleLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 4, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        titleTextField.setAnchorSize(to: titleView, widthMultiplier: 0.9, heightMultiplier: nil)
        titleTextField.setAnchorSize(width: nil, height: 40)
        addSingleButtonToolbar(textField: titleTextField, textView: nil, name: "Done", target: self, action: #selector(dismissTextView))
        titleSeparator.setAnchors(top: titleView.bottomAnchor, leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleSeparator.setAnchorSize(width: nil, height: 0.5)
        
        // Date and Time
        dateView.setAnchors(top: titleSeparator.bottomAnchor, leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        dateView.setAnchorSize(to: titleView, widthMultiplier: nil, heightMultiplier: 1)
        completeDateTimeStack.setAnchors(top: nil, leading: dateView.leadingAnchor, trailing: dateView.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: 20, bottomConstant: nil)
        completeDateTimeStack.center(toVertically: dateView, toHorizontally: nil)
        startDateSeparator.setAnchorSize(width: 1, height: nil)
        startTimeSeparator.setAnchorSize(to: startDateSeparator, widthMultiplier: 1, heightMultiplier: 1)
        completeDateTimeSeparator.setAnchors(top: dateView.bottomAnchor, leading: dateView.leadingAnchor, trailing: dateView.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        completeDateTimeSeparator.setAnchorSize(width: nil, height: 0.5)
        
        // All day
        allDayCheckButton.setAnchors(top: completeDateTimeSeparator.bottomAnchor, leading: addTitleLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        allDayCheckButton.setAnchorSize(width: 200, height: nil)
        
        // Location
        locationLabel.setAnchors(top: allDayCheckButton.bottomAnchor, leading: addTitleLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        locationImageView.setAnchors(top: nil, leading: locationLabel.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        locationImageView.setAnchorSize(width: 20, height: 20)
        locationImageView.center(toVertically: locationLabel, toHorizontally: nil)
        locationView.setAnchors(top: locationLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        locationView.setAnchorSize(width: nil, height: 60)
        locationButton.setAnchors(top: locationView.topAnchor, leading: locationView.leadingAnchor, trailing: locationView.trailingAnchor, bottom: locationView.bottomAnchor, topConstant: 0, leadingConstant: 20, trailingConstant: 40, bottomConstant: 0)
        locationCloseButton.setAnchors(top: locationView.topAnchor, leading: nil, trailing: locationView.trailingAnchor, bottom: locationView.bottomAnchor, topConstant: 0, leadingConstant: nil, trailingConstant: 0, bottomConstant: 0)
        locationCloseButton.widthAnchor.constraint(equalTo: locationView.heightAnchor, multiplier: 1).isActive = true
        
        // Note
        noteLabel.setAnchors(top: locationView.bottomAnchor, leading: addTitleLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
        noteImageView.setAnchors(top: nil, leading: noteLabel.trailingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 10, trailingConstant: nil, bottomConstant: nil)
        noteImageView.setAnchorSize(width: 20, height: 20)
        noteImageView.center(toVertically: noteLabel, toHorizontally: nil)
        noteView.setAnchors(top: noteLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 80 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
        noteTextView.fillSuperView()
        addSingleButtonToolbar(textView: noteTextView, name: "Done", target: self, action: #selector(dismissTextView))
    }
    
    @objc func dismissTextView(){
        endEditing(true)
    }
    
    func setLocationLabel(name: String, address: String){
        let attributedString = NSMutableAttributedString(string: name, attributes: [.font: UIFont(name: "Lato-Regular", size: 16) ?? UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor(r: 44, g: 44, b: 44, a: 1)])
        attributedString.appendNewLine()
        attributedString.append(NSAttributedString(string: address, attributes: [.font : UIFont(name: "Lato-Light", size: 14) ?? UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor(r: 44, g: 44, b: 44, a: 1)]))
        
        locationCloseButton.isHidden = false
        
        UIView.performWithoutAnimation {
            locationButton.setAttributedTitle(attributedString, for: .normal)
            locationButton.layoutIfNeeded()
        }
    }
    
    func hideLocationLabel(){
        locationCloseButton.isHidden = true
        let attributedString = NSAttributedString(string: "Set a location", attributes: [.font : UIFont(name: "Lato-Regular", size: 16) ?? UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor(r: 44, g: 44, b: 44, a: 1)])
        UIView.performWithoutAnimation {
            locationButton.setAttributedTitle(attributedString, for: .normal)
            locationButton.layoutIfNeeded()
        }
    }
    
    func getCurrentStartDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.date(from: startDateButton.currentTitle!)!
    }
    
    func getCurrentStartTime() -> Date{
        return getTimeFromButton(button: startTimeButton)
    }
    
    func getCurrentEndTime() -> Date{
        return getTimeFromButton(button: endTimeButton)
    }
    
    func getTimeFromButton(button: UIButton) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = Calendar.current.timeZone
        let timeDate = dateFormatter.date(from: button.currentTitle!)!
        let hour = Calendar.current.component(.hour, from: timeDate)
        let minute = Calendar.current.component(.minute, from: timeDate)
        
        let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
        
        return date
    }
    
    func getSelectedDates() -> (Date, Date?) {
        if isAllday(){
            return (getCurrentStartDate(), nil)
        }
        
        let calendar = Calendar.current
        
        // Start Time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let startTimeDate = dateFormatter.date(from: startTimeButton.currentTitle!)!
        let startHour = Calendar.current.component(.hour, from: startTimeDate)
        let startMinute = Calendar.current.component(.minute, from: startTimeDate)
        
        // End Time
        let endTimeDate = dateFormatter.date(from: endTimeButton.currentTitle!)!
        let endHour = Calendar.current.component(.hour, from: endTimeDate)
        let endMinute = Calendar.current.component(.minute, from: endTimeDate)
        
        // StartDate
        var startDate = getCurrentStartDate()
        startDate = calendar.date(bySetting: .hour, value: startHour, of: startDate)!
        startDate = calendar.date(bySetting: .minute, value: startMinute, of: startDate)!
        
        // EndDate
        var endDate = getCurrentStartDate()
        endDate = calendar.date(bySetting: .hour, value: endHour, of: endDate)!
        endDate = calendar.date(bySetting: .minute, value: endMinute, of: endDate)!
        
        return (startDate, endDate)
    }
    
    func isAllday() -> Bool {
        return startTimeLabel.isHidden
    }
    
    func allDay(on: Bool){
        startDateSeparator.isHidden = on
        startTimeLabel.isHidden = on
        startTimeButton.isHidden = on
        startTimeSeparator.isHidden = on
        endTimeLabel.isHidden = on
        endTimeButton.isHidden = on
    }

    func enableTextViewPlaceholder(){
        noteTextView.font = UIFont(name: "Lato-Light", size: 18)
        noteTextView.text = "Add some notes"
        noteTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 0.6)
    }
    
    func disableTextViewPlaceholder(){
        noteTextView.text = ""
        noteTextView.font = UIFont(name: "Lato-Regular", size: 18)
        noteTextView.textColor = UIColor(r: 44, g: 44, b: 44, a: 1)
    }
    
    func loadData(event: Event){
        titleTextField.text = event.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        startDateButton.setTitle(dateFormatter.string(from: event.startDate), for: .normal)
        
        if event.allDay{
            allDayCheckButton.setImage(UIImage(named: "smallCheckboxOn")?.withRenderingMode(.alwaysOriginal), for: .normal)
            allDay(on: true)
        }else{
            allDayCheckButton.setImage(UIImage(named: "smallCheckboxOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
            allDay(on: false)
            
            dateFormatter.dateFormat = "hh:mm a"
            startTimeButton.setTitle(dateFormatter.string(from: event.startDate), for: .normal)
            endTimeButton.setTitle(dateFormatter.string(from: event.endDate ?? Date()), for: .normal)
        }
        
        if let placeName = event.placeName, let address = event.address{
            setLocationLabel(name: placeName, address: address)
        }
        
        if let note = event.note{
            disableTextViewPlaceholder()
            noteTextView.text = note
        }
    }
}
