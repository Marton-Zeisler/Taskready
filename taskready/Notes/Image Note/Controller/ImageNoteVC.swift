//
//  ImageNoteVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 26..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ImageNoteVC: UIViewController {
    
    var mainView: ImageNoteView!
    var imageNote: ImageNote?
    weak var noteDelegate: NoteDelegate?
    var selectedIndexPath: IndexPath?
    var editMode = true
    
    // Color Picker View
    var colorPickerVew: ColorPickerView!
    let colors = Statics.colorPickers
    var colorPickerDown = true
    var selectedColorIndex = 2
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if colorPickerVew == nil{
            setupColorPicker()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationbar()
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
        var imageLocation: String? = nil
        let color = colors[selectedColorIndex].getRealmColorString() ?? ""
        
        // Saving the image
        if mainView.imageView.image != nil{
            if let data = mainView.imageView.image?.jpegData(compressionQuality: 1), let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                let url = documentsDirectory.appendingPathComponent(UUID().uuidString)
                if let savedLocation = saveImage(data: data, url: url){
                    imageLocation = savedLocation
                }else{
                    showErrorMessage()
                }
            }else{
                showErrorMessage()
                return
            }
        }
        
        if let imageNote = imageNote{
            // Update note
            let updatedNote = ImageNote(title: mainView.titleField.text!, color: color, imageLocation: imageLocation)
            imageNote.updateNote(updatedNote: updatedNote) { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.changedNote(newNote: imageNote, indexPath: self.selectedIndexPath)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }else{
            // Create new note
            imageNote = ImageNote(title: mainView.titleField.text!, color: color, imageLocation: imageLocation)
            imageNote?.saveNewNote(handler: { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.addedNote(note: self.imageNote!)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            })
        }
    }
    
    func saveChangesView(){
        self.navigationItem.title = self.imageNote?.note?.title
        editMode = false
        updateEditModeView(editMode)
    }
    
    func saveImage(data: Data, url: URL) ->String?{
        do{
            try data.write(to: url)
            return url.absoluteString
        }catch{
            #if DEBUG
                print("Error saving file")
            #endif
            return nil
        }
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
            self.imageNote?.deleteNote(handler: { (success) in
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
    
    @objc func addImageTapped(){
        let sourceAlertVC = UIAlertController(title: "Source Type", message: "Please select your source type", preferredStyle: .actionSheet)
        sourceAlertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        sourceAlertVC.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        sourceAlertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sourceAlertVC, animated: true, completion: nil)
    }
    
    @objc func closeImageTapped(){
        mainView.imageView.image = nil
        mainView.closeImageButton.isHidden = true
        mainView.addButton.isHidden = false
    }
}

extension ImageNoteVC{
    func setups(){
        mainView = ImageNoteView()
        
        if let imageNote = imageNote{
            var image: UIImage? = nil
            if let imageLocation = imageNote.imageLocation, let url = URL(string: imageLocation){
                image = UIImage(contentsOfFile: url.path)
            }
            
            if let index = colors.firstIndex(of: UIColor(realmString: imageNote.note?.color ?? "")){
                selectedColorIndex = index
            }
            
            mainView.loadData(title: imageNote.note?.title, image: image)
        }
        
        mainView.setEditMode(editMode)
        
        self.view = mainView
        mainView.removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        mainView.addButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        mainView.closeImageButton.addTarget(self, action: #selector(closeImageTapped), for: .touchUpInside)
    }
    
    func setupNavigationbar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if let imageNote = imageNote{
            navigationItem.title = imageNote.note?.title
            navigationController?.navigationBar.barTintColor = UIColor(realmString: imageNote.note?.color ?? "")
        }else{
            navigationItem.title = "Add Image"
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
}

extension ImageNoteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension ImageNoteVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: colorPickerVew.colorsCollectionView)
        return location.y <= 0
    }
}

extension ImageNoteVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        mainView.imageView.image = image
        mainView.addButton.isHidden = true
        mainView.closeImageButton.isHidden = false
    }
}
