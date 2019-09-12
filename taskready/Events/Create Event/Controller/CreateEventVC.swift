//
//  CreateEventVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 02..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit

class CreateEventVC: UIViewController {

    var mainView: CreateEventView!
    private var scrollView: UIScrollView!
    private var activeInputView: UIView?
    var event: Event?
    var editMode = false
    weak var viewEventDelegate: ViewEventDelegate?
    
    var datePicker: UIDatePicker!
    var editingDateTimeButton: UIButton?
    
    // Color Picker View
    var colorPickerVew: ColorPickerView!
    let colors = Statics.colorPickers
    var colorPickerDown = true
    var selectedColorIndex = 3
    
    var placeName: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    weak var eventDelegate: EventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if colorPickerVew == nil{
            setupColorPicker()
        }
    }
    
    func setupColorPicker(){
        // 20 + 20 + (10 * 5) = 90
        let cellSize = (self.view.frame.width - 90) / 6
        // 20 + 17 + 20 + 8 + 1 + 20 + 20 + 20 = 126
        let fullHeight = cellSize + cellSize + 126 + view.safeAreaInsets.bottom 
        // 20 + 20 + 20
        let smallHeight: CGFloat = 60 + view.safeAreaInsets.bottom
        colorPickerVew = ColorPickerView(frame: CGRect(x: 0, y: self.view.frame.height-smallHeight, width: self.view.frame.width, height: fullHeight))
        
        self.view.addSubview(colorPickerVew)
        colorPickerVew.colorsCollectionView.delegate = self
        colorPickerVew.colorsCollectionView.dataSource = self
        colorPickerVew.actionButton.addTarget(self, action: #selector(colorPickerRightButtonTapped), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(colorPickerRightButtonTapped))
        tapGestureRecognizer.delegate = self
        colorPickerVew.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func colorPickerRightButtonTapped(){
        colorPickerDown = !colorPickerDown
        
        if colorPickerDown{
            // Bring it down
            colorPickerVew.bringDownColorPicker()
        }else{
            // Bring it up
            colorPickerVew.bringUpColorPicker()
        }
    }
    
    func checkInputs() -> Bool {
        if !mainView.titleTextField.hasText{
            titleMissingAlert()
            return false
        }else{
            return true
        }
    }
    
    func titleMissingAlert(){
        let alertVC = UIAlertController(title: "Title missing", message: "Please set a name for your event!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped(){
        if !checkInputs(){
            return
        }
        
        saveChanges()
    }
    
    func saveChanges(){
        let color = colors[selectedColorIndex].getRealmColorString() ?? ""
        var note: String? = nil
        if mainView.noteTextView.hasText && mainView.noteTextView.font != UIFont(name: "Lato-Light", size: 18) {
            note = mainView.noteTextView.text
        }
        let dates = mainView.getSelectedDates()
        let newEvent = Event(title: mainView.titleTextField.text!, color: color, startDate: dates.0, endDate: dates.1, allDay: mainView.isAllday(), address: address, placeName: placeName, latitude: latitude, longitude: longitude, note: note)
        
        
        if let event = event{
            let oldDate = event.startDate
            let oldColor = UIColor(realmString: event.color)
            event.updateEventRealm(updatedEvent: newEvent) { (success) in
                if success{
                    self.viewEventDelegate?.updatedEvent(event: event, oldDate: oldDate, oldColor: oldColor)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }else{
            // Create new event
            newEvent.saveNewEvent { (success) in
                if success{
                    self.eventDelegate?.addedEvent(event: newEvent)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if !editMode {
            navigationController?.setupDefaultBarStyle()
        }
    }
    
    func setupDefaultStartEndDateTimes(){
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let hour = calendar.component(.hour, from: currentDate)
        if hour == 22{
            mainView.startDateButton.setTitle(dateFormatter.string(from: calendar.date(byAdding: .day, value: 1, to: currentDate)!), for: .normal)
            mainView.startTimeButton.setTitle("08:00 AM", for: .normal)
            mainView.endTimeButton.setTitle("09:00 AM", for: .normal)
        }else{
            mainView.startDateButton.setTitle(dateFormatter.string(from: currentDate), for: .normal)
            let startTimeDate = calendar.date(byAdding: .hour, value: 1, to: currentDate)!
            let endTimeDate = calendar.date(byAdding: .hour, value: 2, to: currentDate)!
            dateFormatter.dateFormat = "hh:mm a"
            mainView.startTimeButton.setTitle(dateFormatter.string(from: startTimeDate), for: .normal)
            mainView.endTimeButton.setTitle(dateFormatter.string(from: endTimeDate), for: .normal)
        }
    }
    
    @objc func startDateTapped(){
        editingDateTimeButton = mainView.startDateButton
        datePicker.datePickerMode = .date
        datePicker.setDate(mainView.getCurrentStartDate(), animated: true)
        datePicker.minimumDate = Date()
        
        mainView.textField.becomeFirstResponder()
    }
    
    @objc func startTimeTapped(){
        editingDateTimeButton = mainView.startTimeButton
        datePicker.datePickerMode = .time
        datePicker.setDate(mainView.getCurrentStartTime(), animated: true)
        
        if Calendar.current.isDateInToday(mainView.getCurrentStartDate()){
            datePicker.minimumDate = Date()
        }else{
            datePicker.minimumDate = nil
        }
        
        mainView.textField.becomeFirstResponder()
    }
    
    @objc func endTimeTapped(){
        editingDateTimeButton = mainView.endTimeButton
        datePicker.datePickerMode = .time
        datePicker.setDate(mainView.getCurrentEndTime(), animated: true)
        datePicker.minimumDate = mainView.getCurrentStartTime()
        
        mainView.textField.becomeFirstResponder()
    }

    @objc func dateTimePickerSelected(){
        mainView.textField.endEditing(true)
    }
    
    @objc func dateTimePickerChanged(){
        let dateFormatter = DateFormatter()
        
        if editingDateTimeButton == mainView.startDateButton{
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            UIView.performWithoutAnimation {
                self.mainView.startDateButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
                self.mainView.startDateButton.layoutIfNeeded()
            }
            
            if Calendar.current.isDateInToday(datePicker.date){
                let startTimeDate = mainView.getTimeFromButton(button: mainView.startTimeButton)
                if startTimeDate < Date(){
                    dateFormatter.dateFormat = "hh:mm a"
                    UIView.performWithoutAnimation {
                        self.mainView.startTimeButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
                        self.mainView.startTimeButton.layoutIfNeeded()
                        self.mainView.endTimeButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
                        self.mainView.endTimeButton.layoutIfNeeded()
                    }
                    
                }
            }
        }else if editingDateTimeButton == mainView.startTimeButton{
            dateFormatter.dateFormat = "hh:mm a"
            UIView.performWithoutAnimation {
                self.mainView.startTimeButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
                self.mainView.startTimeButton.layoutIfNeeded()
            }
            
            
            let startTimeDate = mainView.getTimeFromButton(button: mainView.startTimeButton)
            let endTimeDate = mainView.getTimeFromButton(button: mainView.endTimeButton)
            
            if endTimeDate < startTimeDate{
                UIView.performWithoutAnimation {
                    self.mainView.endTimeButton.setTitle(dateFormatter.string(from: startTimeDate), for: .normal)
                    self.mainView.endTimeButton.layoutIfNeeded()
                }
                
            }
            
        }else if editingDateTimeButton == mainView.endTimeButton{
            dateFormatter.dateFormat = "hh:mm a"
            UIView.performWithoutAnimation {
                self.mainView.endTimeButton.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
                self.mainView.endTimeButton.layoutIfNeeded()
            }
        }
    }
    
    @objc func allDayTapped(){
        if mainView.allDayCheckButton.imageView!.image == UIImage(named: "smallCheckboxOff")?.withRenderingMode(.alwaysOriginal){
            mainView.allDayCheckButton.setImage(UIImage(named: "smallCheckboxOn")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mainView.allDay(on: true)
        }else{
            mainView.allDayCheckButton.setImage(UIImage(named: "smallCheckboxOff")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mainView.allDay(on: false)
        }
    }
    
    @objc func locationTapped(){
        showPlacesResults()
    }
    
    func showPlacesResults(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func locationCloseTapped(){
        mainView.hideLocationLabel()
        
        latitude = nil
        longitude = nil
        address = nil
        placeName = nil
    }
    
}

extension CreateEventVC{
    func setups(){
        // ScrollView Setup
        mainView = CreateEventView()
        setupDefaultStartEndDateTimes()
        
        if let event = event{
            mainView.loadData(event: event)
            placeName = event.placeName
            address = event.address
            latitude = event.latitude.value
            longitude = event.longitude.value
            
            selectedColorIndex = colors.firstIndex(of: UIColor(realmString: event.color)) ?? selectedColorIndex
        }
        
        scrollView = UIScrollView(frame: .zero)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(mainView)
        scrollView.setAnchors(top: self.view.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: self.view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        scrollView.backgroundColor = UIColor(r: 248, g: 248, b: 248, a: 1)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.keyboardDismissMode = .interactive
        mainView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: 0).isActive = true
        mainView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: 0).isActive = true
        
        mainView.setAnchors(top: scrollView.contentLayoutGuide.topAnchor, leading: scrollView.contentLayoutGuide.leadingAnchor, trailing: scrollView.contentLayoutGuide.trailingAnchor, bottom: scrollView.contentLayoutGuide.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        
        
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(dateTimePickerChanged), for: .valueChanged)
        hideKeyboardWhenTappedAround(cancelTouches: false)
        mainView.startDateButton.addTarget(self, action: #selector(startDateTapped), for: .touchUpInside)
        mainView.startTimeButton.addTarget(self, action: #selector(startTimeTapped), for: .touchUpInside)
        mainView.endTimeButton.addTarget(self, action: #selector(endTimeTapped), for: .touchUpInside)
        mainView.textField.inputView = datePicker
        mainView.addSingleButtonToolbar(textField: mainView.textField, name: "Done", target: self, action: #selector(dateTimePickerSelected))
        mainView.allDayCheckButton.addTarget(self, action: #selector(allDayTapped), for: .touchUpInside)
        mainView.locationButton.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
        mainView.locationCloseButton.addTarget(self, action: #selector(locationCloseTapped), for: .touchUpInside)
        mainView.noteTextView.delegate = self
        mainView.titleTextField.delegate = self
        mainView.textField.delegate = self
    }
    
    @objc func keyboardUp(notification: NSNotification){
        var info = notification.userInfo!
        
        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardRect = self.view.convert(keyboardRect, from: nil)
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.size.height+20, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        let activeView = activeInputView?.frame ?? mainView.noteView.frame
        if keyboardRect.origin.y < activeView.maxY{
            self.scrollView.scrollRectToVisible(activeView, animated: true)
        }
        
    }
    
    @objc func keyboardDown(notification: NSNotification){
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.setContentOffset(.zero, animated: true)
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        
        if let event = event{
            navigationItem.title = "Edit Event"
            navigationController?.navigationBar.barTintColor = UIColor(realmString: event.color)
        }else{
            navigationItem.title = "Add Event"
            navigationController?.navigationBar.barTintColor = UIColor(r: 113, g: 166, b: 220, a: 1)
        }
        
    }
}

extension CreateEventVC: UITextViewDelegate, UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeInputView = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeInputView = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.font == UIFont(name: "Lato-Light", size: 18){
            mainView.disableTextViewPlaceholder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        textView.setContentOffset(.zero, animated: true)
        
        if !textView.hasText{
            mainView.enableTextViewPlaceholder()
        }
    }
}

extension CreateEventVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        
        cell.setColor(color: colors[indexPath.item])
        cell.tickImageView.isHidden = indexPath.item != selectedColorIndex
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20 + 20 + (10 * 5) = 90
        let width = (collectionView.frame.width - 90) / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColorIndex = indexPath.item
        navigationController?.navigationBar.barTintColor = colors[selectedColorIndex]
        collectionView.reloadData()
    }
    
}

extension CreateEventVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: colorPickerVew.colorsCollectionView)
        return location.y <= 0
    }
}

extension CreateEventVC: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        address = place.formattedAddress ?? ""
        placeName = place.name ?? ""
        
        mainView.setLocationLabel(name: place.name ?? "", address: place.formattedAddress ?? "")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        #if DEBUG
            print("Error: ", error.localizedDescription)
        #endif
        showErrorMessage()
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
