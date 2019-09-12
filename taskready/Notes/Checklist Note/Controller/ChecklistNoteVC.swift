//
//  ChecklistNoteVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 20..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistNoteVC: UIViewController {

    var mainView: ChecklistNoteView!
    var editMode = true
    var checklistNote: ChecklistNote?
    weak var noteDelegate: NoteDelegate?
    var selectedIndexPath: IndexPath?
    var checklistItems = List<ChecklistItem>()
    
    // Color Picker View
    var colorPickerVew: ColorPickerView!
    let colors = Statics.colorPickers
    var colorPickerDown = true
    var selectedColorIndex = 2
    
    var originalTableViewHeight: CGFloat = 0
    var scrollInsertIndexPath: IndexPath?
    var editingTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if colorPickerVew == nil{
            setupColorPicker()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    func setupColorPicker(){
        // 20 + 20 + (10 * 5) = 90
        let cellSize = (self.view.frame.width - 90) / 6
        // 20 + 17 + 20 + 8 + 1 + 20 + 20 + 20 = 126
        let fullHeight = cellSize + cellSize + 126 + view.safeAreaInsets.bottom
        // 20 + 20 + 20
        let smallHeight: CGFloat = 60 + view.safeAreaInsets.bottom
        colorPickerVew = ColorPickerView(frame: CGRect(x: 0, y: self.view.frame.height-smallHeight, width: self.view.frame.width, height: fullHeight))
        colorPickerVew.isHidden = !editMode
        
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
    
    @objc func rightBarButtonTapped(){
        self.view.endEditing(true)
        
        if editMode{
            // Save changes
            if !mainView.titleField.hasText{
                let alertVC = UIAlertController(title: "Title required", message: "Please give your note a title!", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertVC, animated: true, completion: nil)
            }else{
                saveChanges()
            }
        }else{
            // Turn on edit mode
            editMode = true
            updateEditModeView(editMode)
        }
    }
    
    func saveChanges(){
        if checklistNote != nil{
            // Update note
            updateChanges(switchToViewMode: true)
        }else{
            // Create new Note
            let color = colors[selectedColorIndex].getRealmColorString() ?? ""
            
            checklistNote = ChecklistNote(title: mainView.titleField.text!, color: color, checklistItems: checklistItems)
            checklistNote?.saveNewNote(handler: { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.addedNote(note: self.checklistNote!)
                }else{
                    self.showErrorMessage()
                }
            })
        }
    }
    
    func updateChanges(switchToViewMode: Bool){
        guard let checklistNote = checklistNote else { return }
        let color = colors[selectedColorIndex].getRealmColorString() ?? ""
        
        let updatedNote = ChecklistNote(title: mainView.titleField.text!, color: color, checklistItems: checklistItems)
        checklistNote.updateNote(updatedNote: updatedNote, handler: { (success) in
            if success{
                if switchToViewMode{
                    self.saveChangesView()
                }
                
                self.noteDelegate?.changedNote(newNote: checklistNote, indexPath: self.selectedIndexPath)
            }else{
                self.showErrorMessage()
            }
        })
        
    }
    
    func saveChangesView(){
        self.navigationItem.title = self.checklistNote?.note?.title
        self.editMode = false
        self.updateEditModeView(self.editMode)
    }
    
    func updateEditModeView(_ isEdit: Bool){
        if isEdit{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(rightBarButtonTapped))
            colorPickerVew.isHidden = false
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(rightBarButtonTapped))
            colorPickerVew.isHidden = true
        }
        
        mainView.tableView.reloadData()
        mainView.setEditMode(isEdit)
    }
    
    @objc func removeTapped(){
        let alertVC = UIAlertController(title: "Confirm your action", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.checklistNote?.deleteNote(handler: { (success) in
                if success{
                    self.noteDelegate?.deletedNote(indexPath: self.selectedIndexPath)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            })
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func addCheckBoxTapped(){
        if let textField = editingTextField{
            textFieldAddItem(textField: textField)
        }else{
            checklistItems.append(ChecklistItem(title: "", completed: false))
            let insertIndexPath = IndexPath(row: checklistItems.count-1, section: 0)
            mainView.tableView.insertRows(at: [insertIndexPath], with: .fade)
            scrollToIndexPathInsertion(insertIndexPath: insertIndexPath)
        }

    }
    
    func scrollToIndexPathInsertion(insertIndexPath: IndexPath){
        if let visibleRows = mainView.tableView.indexPathsForVisibleRows{
            if visibleRows.contains(insertIndexPath){
                guard let cell = mainView.tableView.cellForRow(at: insertIndexPath) as? ChecklistNoteCell else { return }
                cell.titleField.becomeFirstResponder()
            }else{
                scrollInsertIndexPath = insertIndexPath
                mainView.tableView.scrollToRow(at: insertIndexPath, at: .bottom, animated: true)
            }
        }else{
            guard let cell = mainView.tableView.cellForRow(at: insertIndexPath) as? ChecklistNoteCell else { return }
            cell.titleField.becomeFirstResponder()
        }
    }

}

extension ChecklistNoteVC{
    func setups(){
        mainView = ChecklistNoteView()
        
        if let checklistNote = checklistNote{
            mainView.loadData(checklistNote: checklistNote)
            copyListByValue(source: checklistNote.checklistItems)
            mainView.tableView.reloadData()
            
            if let index = colors.firstIndex(of: UIColor(realmString: checklistNote.note?.color ?? "")){
                selectedColorIndex = index
            }
        }
        
        mainView.setEditMode(editMode)
        self.view = mainView
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.addCheckButton.addTarget(self, action: #selector(addCheckBoxTapped), for: .touchUpInside)
        mainView.removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        //hideKeyboardWhenTappedAround(cancelTouches: true)
    }
    
    func copyListByValue(source: List<ChecklistItem>){
        for each in source{
            checklistItems.append(ChecklistItem(title: each.title, completed: each.completed))
        }
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if let checklistNote = checklistNote {
            navigationItem.title = checklistNote.note?.title
            navigationController?.navigationBar.barTintColor = UIColor(realmString: checklistNote.note?.color ?? "")
        }else{
            navigationItem.title = "Add Note"
            navigationController?.navigationBar.barTintColor = UIColor(r: 157, g: 146, b: 212, a: 1)
        }
        
        if editMode{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(rightBarButtonTapped))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(rightBarButtonTapped))
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.setupDefaultBarStyle()
    }
    
    @objc func keyboardUp(notification: NSNotification){
        var info = notification.userInfo!
        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardRect = self.view.convert(keyboardRect, from: nil)
        
        originalTableViewHeight = originalTableViewHeight == 0 ? mainView.tableView.frame.height : originalTableViewHeight
        let newHeight = self.view.frame.height - mainView.tableView.frame.origin.y - keyboardRect.height
    
        let tableViewFrame = mainView.tableView.frame
        mainView.tableView.frame = CGRect(x: tableViewFrame.origin.x, y: tableViewFrame.origin.y, width: tableViewFrame.width, height: newHeight)
    }
    
    @objc func keyboardDown(notification: NSNotification){
        var info = notification.userInfo!
        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardRect = self.view.convert(keyboardRect, from: nil)
        
        let tableViewFrame = mainView.tableView.frame
        mainView.tableView.frame = CGRect(x: tableViewFrame.origin.x, y: tableViewFrame.origin.y, width: tableViewFrame.width, height: originalTableViewHeight)
    }
    
    
}

extension ChecklistNoteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension ChecklistNoteVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: colorPickerVew.colorsCollectionView)
        return location.y <= 0
    }
}

extension ChecklistNoteVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistNoteCell", for: indexPath) as? ChecklistNoteCell else {
            return UITableViewCell()
        }
        
        let item = checklistItems[indexPath.row]
        cell.setupData(item: item)
        cell.checkBoxButton.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        cell.titleField.addTarget(self, action: #selector(checkBoxTitleChanged(_:)), for: .editingChanged)
        cell.setEditMode(editing: editMode)
        cell.titleField.delegate = self
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldAddItem(textField: textField)

        return true
    }
    
    func textFieldAddItem(textField: UITextField){
        let position = textField.convert(CGPoint.zero, to: mainView.tableView)
        if let selectedIndexPath = mainView.tableView.indexPathForRow(at: position){
            let insertIndexPath = IndexPath(row: selectedIndexPath.row+1, section: 0)
            checklistItems.insert(ChecklistItem(title: "", completed: false), at: insertIndexPath.row)
            mainView.tableView.insertRows(at: [insertIndexPath], with: .fade)
            scrollToIndexPathInsertion(insertIndexPath: insertIndexPath)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editingTextField = nil
    }
    
    @objc func checkBoxTapped(_ sender: UIButton){
        let position = sender.convert(CGPoint.zero, to: mainView.tableView)
        if let indexPath = mainView.tableView.indexPathForRow(at: position), let cell =
            mainView.tableView.cellForRow(at: indexPath) as? ChecklistNoteCell{
            checklistItems[indexPath.row].completed = !checklistItems[indexPath.row].completed
            cell.setupData(item: checklistItems[indexPath.row])
            
            if !editMode{
                updateChanges(switchToViewMode: false)
            }
        }
    }
    
    @objc func checkBoxTitleChanged(_ sender: UITextField){
        let position = sender.convert(CGPoint.zero, to: mainView.tableView)
        if let indexPath = mainView.tableView.indexPathForRow(at: position), let cell = mainView.tableView.cellForRow(at: indexPath) as? ChecklistNoteCell{
            checklistItems[indexPath.row].title = sender.text ?? ""
            cell.setupData(item: checklistItems[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = checklistItems[sourceIndexPath.row]
        checklistItems.remove(at: sourceIndexPath.row)
        checklistItems.insert(movedItem, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            checklistItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if !editMode{
                updateChanges(switchToViewMode: false)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = scrollInsertIndexPath{
            if let cell = mainView.tableView.cellForRow(at: indexPath) as? ChecklistNoteCell{
                cell.titleField.becomeFirstResponder()
                scrollInsertIndexPath = nil
            }
        }
    }
}
