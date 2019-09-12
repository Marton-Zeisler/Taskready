//
//  TextNoteVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 20..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class TextNoteVC: UIViewController{
    
    var mainView: TextNoteView!
    var editMode = true
    var textNote: TextNote?
    weak var noteDelegate: NoteDelegate?
    var selectedIndexPath: IndexPath?
    
    // Color Picker View
    var colorPickerVew: ColorPickerView!
    let colors = Statics.colorPickers
    var colorPickerDown = true
    var selectedColorIndex = 2
    
    var textViewOriginalHeight: CGFloat = 0

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
        let color = colors[selectedColorIndex].getRealmColorString() ?? ""
        var descr: String? = nil
        if mainView.descriptionTextView.hasText && mainView.descriptionTextView.font != UIFont(name: "Lato-Light", size: 18) {
            descr = mainView.descriptionTextView.text
        }
        
        if let textNote = textNote{
            let updatedNote = TextNote(title: mainView.titleField.text!, color: color, descr: descr)
            textNote.updateNote(updatedNote: updatedNote) { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.changedNote(newNote: textNote, indexPath: self.selectedIndexPath)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }else{
            textNote = TextNote(title: mainView.titleField.text!, color: color, descr: descr)
            textNote?.saveNewNote(handler: { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.addedNote(note: self.textNote!)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            })
        }
    }
    
    func saveChangesView(){
        self.navigationItem.title = self.textNote?.note?.title
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
        
        mainView.setEditMode(isEdit)
    }
    
    @objc func removeTapped(){
        let alertVC = UIAlertController(title: "Confirm your action", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.textNote?.deleteNote(handler: { (success) in
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
    
}

extension TextNoteVC{
    func setups(){
        mainView = TextNoteView()
    
        if let textNote = textNote{
            mainView.loadData(textNote: textNote)
            if let index = colors.firstIndex(of: UIColor(realmString: textNote.note?.color ?? "")){
                selectedColorIndex = index
            }
        }
        
        mainView.setEditMode(editMode)
        
        self.view = mainView
        mainView.removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if let textNote = textNote {
            navigationItem.title = textNote.note?.title
            navigationController?.navigationBar.barTintColor = UIColor(realmString: textNote.note?.color ?? "")
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
        
        textViewOriginalHeight = textViewOriginalHeight == 0 ? mainView.descriptionTextView.frame.height : textViewOriginalHeight
        let newHeight = self.view.frame.height - mainView.descriptionTextView.frame.origin.y - keyboardRect.height
        let descriptionFrame = mainView.descriptionTextView.frame
        mainView.descriptionTextView.frame = CGRect(x: descriptionFrame.origin.x, y: descriptionFrame.origin.y, width: descriptionFrame.width, height: newHeight)
    }
    
    @objc func keyboardDown(notification: NSNotification){
        var info = notification.userInfo!
        guard var keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardRect = self.view.convert(keyboardRect, from: nil)

        let descriptionFrame = mainView.descriptionTextView.frame
        mainView.descriptionTextView.frame = CGRect(x: descriptionFrame.origin.x, y: descriptionFrame.origin.y, width: descriptionFrame.width, height: textViewOriginalHeight)
    }
}

extension TextNoteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension TextNoteVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: colorPickerVew.colorsCollectionView)
        return location.y <= 0
    }
}

