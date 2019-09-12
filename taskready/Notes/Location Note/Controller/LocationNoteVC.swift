//
//  LocationNoteVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 22..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import MapKit

class LocationNoteVC: UIViewController {
    
    var mainView: LocationNoteView!
    var editMode = true
    var locationNote: LocationNote?
    weak var noteDelegate: NoteDelegate?
    var selectedIndexPath: IndexPath?
    
    // Color Picker View
    var colorPickerVew: ColorPickerView!
    let colors = Statics.colorPickers
    var colorPickerDown = true
    var selectedColorIndex = 2
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    var tappedPin: MKPointAnnotation?
    
    let searchRequest = MKLocalSearch.Request()
    var resultLocations = [(String, CLLocationCoordinate2D)]()
    var selectedLocation: (latitude: Double, longitude: Double, title: String?)?
    
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
            
            if locationManager == nil{
                setupMap()
            }
        }
    }
    
    func saveChanges(){
        let color = colors[selectedColorIndex].getRealmColorString() ?? ""
        
        if let locationNote = locationNote{
            // Update note
            let updatedNote = LocationNote(title: mainView.titleField.text!, color: color, latitude: selectedLocation?.latitude, longitude: selectedLocation?.longitude, locationName: selectedLocation?.title)
            locationNote.updateNote(updatedNote: updatedNote) { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.changedNote(newNote: locationNote, indexPath: self.selectedIndexPath)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }else{
            // Create new Note
            locationNote = LocationNote(title: mainView.titleField.text!, color: color, latitude: selectedLocation?.latitude, longitude: selectedLocation?.longitude, locationName: selectedLocation?.title)
            locationNote?.saveNewNote(handler: { (success) in
                if success{
                    self.saveChangesView()
                    self.noteDelegate?.addedNote(note: self.locationNote!)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            })
        }
    }
    
    func saveChangesView(){
        self.navigationItem.title = self.locationNote?.note?.title
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
        
        if !isEdit{
            mainView.mapView.isHidden = selectedLocation == nil
            mainView.locationButton.isHidden = selectedLocation == nil
        }else{
            mainView.mapView.isHidden = false
            mainView.locationButton.isHidden = false
        }
    }
    
    @objc func removeTapped(){
        let alertVC = UIAlertController(title: "Confirm your action", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.locationNote?.deleteNote(handler: { (success) in
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
    
    @objc func locationButtonTapped(){
        if let coordinate = userLocation?.coordinate{
            mainView.mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        }
    }
    
    @objc func mapTapped(_ recognizer: UITapGestureRecognizer){
        if !editMode{
            return
        }
        
        if tappedPin != nil {
            tappedPin = nil
            mainView.mapView.removeAnnotations(mainView.mapView.annotations)
            mainView.searchField.text = ""
            selectedLocation = nil
            return
        }
        
        let touchLocation = recognizer.location(in: mainView.mapView)
        let locationCoordinate = mainView.mapView.convert(touchLocation, toCoordinateFrom: mainView.mapView)
        
        tappedPin = MKPointAnnotation()
        tappedPin!.coordinate = locationCoordinate
        mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        mainView.mapView.addAnnotation(tappedPin!)
        selectedLocation = (Double(locationCoordinate.latitude), Double(locationCoordinate.longitude), nil)
        
        getAddressTitle(coordinate: locationCoordinate)
    }
    
    func getAddressTitle(coordinate: CLLocationCoordinate2D){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error == nil{
                var addressTitle = ""
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                
                // Street address
                if let street = placeMark.thoroughfare {
                    addressTitle.append("\(street), ")
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    addressTitle.append("\(city), ")
                }
                // Country
                if let country = placeMark.country {
                    addressTitle.append("\(country)")
                }
                
                self.tappedPin?.title = addressTitle
                self.selectedLocation?.title = addressTitle
            }
        })
    }
    
    @objc func searchFieldChanged(_ textField: UITextField){
        if textField.hasText{
            searchRequest.naturalLanguageQuery = textField.text
            searchRequest.region = mainView.mapView.region
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let response = response else {
                    #if DEBUG
                        print("error")
                    #endif
                    self.resultLocations.removeAll()
                    self.mainView.resultsTableView.reloadData()
                    self.mainView.resultsView.isHidden = true
                    return
                }
                
                self.resultLocations.removeAll()
                
                for each in response.mapItems{
                    if let name = each.name{
                        self.resultLocations.append((name, each.placemark.coordinate))
                    }
                }
                
                self.mainView.resultsTableView.reloadData()
                self.mainView.resultsView.isHidden = false
            }
            
        }else{
            resultLocations.removeAll()
            mainView.resultsTableView.reloadData()
            mainView.resultsView.isHidden = true
        }
    }

}

extension LocationNoteVC: CLLocationManagerDelegate, MKLocalSearchCompleterDelegate, MKMapViewDelegate {
    func setups(){
        mainView = LocationNoteView()
        mainView.setEditMode(editMode)
        
        if let locationNote = locationNote{
            if let index = colors.firstIndex(of: UIColor(realmString: locationNote.note?.color ?? "")){
                selectedColorIndex = index
            }
            mainView.titleField.text = locationNote.note?.title
            
            if locationNote.latitude.value == nil{
                mainView.mapView.isHidden = true
                mainView.locationButton.isHidden = true
            }else{
                mainView.mapView.isHidden = false
                setupMap()
            }
        }
        
        self.view = mainView
        
        if editMode{
            setupMap()
        }
        
        mainView.removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        mainView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        mainView.searchField.addTarget(self, action: #selector(searchFieldChanged(_:)), for: .editingChanged)
        mainView.resultsTableView.delegate = self
        mainView.resultsTableView.dataSource = self
    }
    
    func setupMap(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mainView.mapView.addGestureRecognizer(tapGestureRecognizer)
        mainView.mapView.delegate = self
        
        if let latitude = locationNote?.latitude.value, let longitude = locationNote?.longitude.value{
            if let latDegrees = CLLocationDegrees(exactly: latitude), let longDegrees = CLLocationDegrees(exactly: longitude){
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees), latitudinalMeters: 1000, longitudinalMeters: 1000)
                mainView.mapView.setRegion(region, animated: true)
                
                tappedPin = MKPointAnnotation()
                tappedPin!.coordinate = CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
                if let title = locationNote?.locationName{
                    tappedPin!.title = title
                }
                
                mainView.mapView.removeAnnotations(mainView.mapView.annotations)
                mainView.mapView.addAnnotation(tappedPin!)
            }
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let userCoordinates = userLocation.coordinate
        self.userLocation = userLocation
        manager.stopUpdatingLocation()
        mainView.locationButton.isHidden = false
        
        if locationNote?.latitude.value == nil && locationNote?.longitude.value == nil{
            let region = MKCoordinateRegion(center: userCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mainView.mapView.setRegion(region, animated: true)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
            print("Error with location manager: \(error.localizedDescription)")
        #endif
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if !editMode{
            if let latitude = locationNote?.latitude.value, let longitude = locationNote?.longitude.value{
                openLocationInMaps(latitude: latitude, longitude: longitude, placeName: locationNote?.locationName)
            }
        }
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if let locationNote = locationNote {
            navigationItem.title = locationNote.note?.title
            navigationController?.navigationBar.barTintColor = UIColor(realmString: locationNote.note?.color ?? "")
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
    
    
}

extension LocationNoteVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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

extension LocationNoteVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: colorPickerVew.colorsCollectionView)
        return location.y <= 0
    }
}

extension LocationNoteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = resultLocations[indexPath.row].0
        
        let selectionBG = UIView()
        selectionBG.layer.cornerRadius = 8
        selectionBG.backgroundColor = .lightGray
        cell.selectedBackgroundView = selectionBG
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = resultLocations[indexPath.row]
        
        mainView.searchField.text = result.0
        mainView.resultsView.isHidden = true
        mainView.searchField.resignFirstResponder()
        
        tappedPin = MKPointAnnotation()
        tappedPin!.coordinate = result.1
        tappedPin!.title = result.0
        let region = MKCoordinateRegion(center: result.1, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mainView.mapView.setRegion(region, animated: true)
        mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        mainView.mapView.addAnnotation(tappedPin!)
        selectedLocation = (result.1.latitude, result.1.longitude, result.0)
    }
}

