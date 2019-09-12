//
//  ToDoTaskVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 19..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import RealmSwift

class ToDoTaskVC: UIViewController {

    var mainView: ToDoTaskView!
    private var scrollView: UIScrollView!
    private var activeInputView: UIView?
    
    var reminderPicker: UIDatePicker!
    var selectedTask: Task!
    var selectedList: TaskList!
    weak var toDoTaskDelegate: ToDoTaskDelegate?
    var selectedTaskOldDate: Date?
    var createMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        loadTask()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionTapped), name: Notification.Name(rawValue: "notificationActionTapped"), object: nil)
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadTask(){
        if selectedTask != nil{
            // Load selected task data
            title = selectedTask.title
            mainView.setActionButtonComplete()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: .done, target: self, action: #selector(deleteTask))
            
            mainView.titleField.text = selectedTask.title
            
            if let date = selectedTask.dateReminder{
                mainView.setClockLabel(date: date)
                selectedTaskOldDate = date
            }
            
            if let note = selectedTask.descr{
                mainView.setNoteText(note)
            }
            
            if let locationName = selectedTask.locationName, let address = selectedTask.address{
                mainView.setLocationLabel(name: locationName, address: address)
            }
        }else{
            // Create empty task
            title = "Add Task"
            selectedTask = Task()
            selectedTask.list = selectedList
            createMode = true
        }
    }
    
    @objc func reminderTapped(){
        reminderPicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
        
        if let date = selectedTask.dateReminder{
            if date >= reminderPicker.minimumDate!{
                reminderPicker.date = date
            } 
        }
        
        datePickerChanged(reminderPicker)
        mainView.textField.becomeFirstResponder()
    }
    
    @objc func datePickerSelected(){
        mainView.textField.endEditing(true)
        datePickerChanged(reminderPicker)
    }
    
    @objc func datePickerChanged(_ datePicker: UIDatePicker){
        let pickedDate = datePicker.date
        mainView.setClockLabel(date: pickedDate)
        
        if createMode{
            selectedTask.dateReminder = pickedDate
        }else{
            let updatedTask = Task(title: selectedTask.title, dateReminder: pickedDate, locationName: selectedTask.locationName, address: selectedTask.address, latitude: selectedTask.latitude.value, longitude: selectedTask.longitude.value, descr: selectedTask.descr, list: selectedList)
            updateTask(updatedTask: updatedTask)
        }
    }
    
    @objc func removeReminderTapped(){
        if createMode{
            selectedTask.dateReminder = nil
        }else{
            let updatedTask = Task(title: selectedTask.title, dateReminder: nil, locationName: selectedTask.locationName, address: selectedTask.address, latitude: selectedTask.latitude.value, longitude: selectedTask.longitude.value, descr: selectedTask.descr, list: selectedList)
            updateTask(updatedTask: updatedTask)
        }
        mainView.removeClockLabel()
    }
    
    @objc func locationTapped(){
        if mainView.locationCloseButton.isHidden{
            // Location not set yet
            showPlacesResults()
        }else{
            // Location set already
            showLocationMap()
        }
    }
    
    @objc func notificationActionTapped(_ notification: Notification){
        if let task = notification.object as? Task{
            if task == selectedTask{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showLocationMap(){
        if let latitude = selectedTask.latitude.value, let longitude = selectedTask.longitude.value{
            openLocationInMaps(latitude: latitude, longitude: longitude, placeName: selectedTask.locationName)
        }
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
        if createMode{
            selectedTask.locationName = nil
            selectedTask.latitude.value = nil
            selectedTask.longitude.value = nil
            selectedTask.address = nil
        }else{
            let updatedTask = Task(title: selectedTask.title, dateReminder: selectedTask.dateReminder, locationName: nil, address: nil, latitude: nil, longitude: nil, descr: selectedTask.descr, list: selectedList)
            updateTask(updatedTask: updatedTask)
        }

        mainView.hideLocationLabel()
    }
    
    @objc func actionTapped(){
        if !checkInputs(){
            return
        }
        
        if createMode{
            // Create new task
            createNewTask()
        }else{
            // Complete task
            completeTask()
        }
    }
    
    func createNewTask(){
        selectedList.addNewTaskRealm(task: selectedTask) { (success) in
            if success{
                if let date = self.selectedTask.dateReminder{
                    self.selectedTask.createNotification(date: date)
                }
                self.toDoTaskDelegate?.createTask(task: self.selectedTask, list: self.selectedList)
                self.navigationController?.popViewController(animated: true)
                self.createMode = false
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    func completeTask(){
        selectedList.completeTaskRealm(task: selectedTask) { (success) in
            if success{
                if self.selectedTask.dateReminder != nil{
                    self.selectedTask.deleteNotification()
                }
                self.toDoTaskDelegate?.deleteTask(oldDate: self.selectedTaskOldDate, task: self.selectedTask, list: self.selectedList)
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    @objc func deleteTask(){
        let alertVC = UIAlertController(title: "Confirm your action", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.selectedList.deleteTaskRealm(task: self.selectedTask, handler: { (success) in
                if success{
                    if self.selectedTask.dateReminder != nil{
                        self.selectedTask.deleteNotification()
                    }
                    self.toDoTaskDelegate?.deleteTask(oldDate: self.selectedTaskOldDate, task: self.selectedTask, list: self.selectedList)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            })
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func updateTask(updatedTask: Task){
        selectedTaskOldDate = selectedTask.dateReminder
        selectedTask.updateTaskRealm(updatedTask: updatedTask) { (success) in
            if success{
                if let date = updatedTask.dateReminder{
                    self.selectedTask.createNotification(date: date)
                }else{
                    self.selectedTask.deleteNotification()
                }
                self.toDoTaskDelegate?.updateTask?(oldDate: self.selectedTaskOldDate, task: self.selectedTask, list: self.selectedList)
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    func checkInputs() -> Bool {
        if !mainView.titleField.hasText{
            titleMissingAlert()
            return false
        }else{
            return true
        }
    }
    
    func titleMissingAlert(){
        let alertVC = UIAlertController(title: "Title missing", message: "Please set a name for your task!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

extension ToDoTaskVC: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if createMode{
            selectedTask.latitude.value = place.coordinate.latitude
            selectedTask.longitude.value = place.coordinate.longitude
            selectedTask.locationName = place.name
            selectedTask.address = place.formattedAddress
        }else{
            let updatedTask = Task(title: selectedTask.title, dateReminder: selectedTask.dateReminder, locationName: place.name, address: place.formattedAddress, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, descr: selectedTask.descr, list: selectedList)
            updateTask(updatedTask: updatedTask)
        }
        
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

extension ToDoTaskVC: UITextFieldDelegate, UITextViewDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeInputView = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeInputView = nil
        
        if textField.hasText{
            if createMode{
                selectedTask.title = textField.text!
                return
            }
        
            self.title = textField.text!
            let updatedTask = Task(title: textField.text!, dateReminder: selectedTask.dateReminder, locationName: selectedTask.locationName, address: selectedTask.address, latitude: selectedTask.latitude.value, longitude: selectedTask.longitude.value, descr: selectedTask.descr, list: selectedList)
            updateTask(updatedTask: updatedTask)
        }
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
            
            if createMode{
                selectedTask.descr = nil
            }else{
                let updatedTask = Task(title: selectedTask.title, dateReminder: selectedTask.dateReminder, locationName: selectedTask.locationName, address: selectedTask.address, latitude: selectedTask.latitude.value, longitude: selectedTask.longitude.value, descr: nil, list: selectedList)
                updateTask(updatedTask: updatedTask)
            }
        }else{
            if createMode{
                selectedTask.descr = textView.text
            }else{
                let updatedTask = Task(title: selectedTask.title, dateReminder: selectedTask.dateReminder, locationName: selectedTask.locationName, address: selectedTask.address, latitude: selectedTask.latitude.value, longitude: selectedTask.longitude.value, descr: textView.text, list: selectedList)
                
                updateTask(updatedTask: updatedTask)
            }
        }
    }
}


extension ToDoTaskVC{
    func setups(){
        reminderPicker = UIDatePicker()
        reminderPicker.datePickerMode = .dateAndTime
        
        // ScrollView Setup
        mainView = ToDoTaskView()
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
        view.addSubview(scrollView)
        
        
        mainView.textField.inputView = reminderPicker
        mainView.addSingleButtonToolbar(textField: mainView.textField, name: "Done", target: self, action: #selector(datePickerSelected))
        reminderPicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        mainView.clockCloseButton.addTarget(self, action: #selector(removeReminderTapped), for: .touchUpInside)
        mainView.clockLabelButton.addTarget(self, action: #selector(reminderTapped), for: .touchUpInside)
        mainView.locationLabelButton.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
        mainView.locationCloseButton.addTarget(self, action: #selector(locationCloseTapped), for: .touchUpInside)
        mainView.actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        mainView.titleField.delegate = self
        mainView.descriptionTextView.delegate = self
        hideKeyboardWhenTappedAround(cancelTouches: true)
    }
    

    
    @objc func keyboardUp(notification: NSNotification){
        for eachView in mainView.subviews{
            if let textField = eachView as? UITextField{
                #if DEBUG
                    print(textField.isFirstResponder)
                #endif
            }
            
            if let textView = eachView as? UITextView{
                #if DEBUG
                    print(textView.isFirstResponder)
                #endif
            }
        }
        
        
        var info = notification.userInfo!
        
        // Keyboard for Text Field:
        // x: 0, y: 343, width: 375, height: 260
        
        // Keyboard Text View:
        // x: 0, y: 299, width: 375, height: 304
        
        // Description View:
        // x: 0, y: 151, width: 375, height: 180
        
        // Text Field:
        // x: 0, y: 0, width: 375, height: 90.5
        
        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardRect = self.view.convert(keyboardRect, from: nil)
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.size.height+20, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        let activeView = activeInputView?.frame ?? mainView.descriptionView.frame
        if keyboardRect.origin.y < activeView.maxY{
            //print("Adjusting scroll view")
            self.scrollView.scrollRectToVisible(activeView, animated: true)
        }
        
    }
    
    @objc func keyboardDown(notification: NSNotification){
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.setContentOffset(.zero, animated: true)
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
}



