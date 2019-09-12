//
//  LocationNoteView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 22..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import MapKit

class LocationNoteView: BaseView, UITextFieldDelegate {

    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter note title"
        field.font = UIFont(name: "Lato-Regular", size: 25)
        field.textColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        field.returnKeyType = .done
        field.minimumFontSize = 8
        return field
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
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        let initialCoordinates = CLLocationCoordinate2DMake(37.7880, -122.4075)
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: initialCoordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        return mapView
    }()
    
    lazy var compassView: MKCompassButton = {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .adaptive
        return compass
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "locationButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.isHidden = true
        return button
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4
        return view
    }()
    
    let searchField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search address"
        field.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        field.returnKeyType = .done
        return field
    }()
    
    let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "searchIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let resultsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    let resultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var mapViewTopAnchor: NSLayoutConstraint!
    
    override func setupViews() {
        backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
        titleView.addSubview(titleField)
        addSubview(titleView)
        addSubview(mapView)
        addSubview(compassView)
        addSubview(locationButton)
        addSubview(searchView)
        searchView.addSubview(searchField)
        searchView.addSubview(searchIconImageView)
        addSubview(resultsView)
        resultsView.addSubview(resultsTableView)
        addSubview(removeButton)
        
        titleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        titleView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.15)
        titleField.center(toVertically: nil, toHorizontally: titleView)
        titleField.setAnchorSize(to: titleView, widthMultiplier: 0.88, heightMultiplier: 1)
        titleField.delegate = self
        addSingleButtonToolbar(textField: titleField, name: "Done", target: self, action: #selector(dismissEditing))
        
        let bottomConstant = CGFloat((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) == 0 ? 0 : 20)
        mapView.setAnchors(top: titleView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: removeButton.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: -bottomConstant)
        mapViewTopAnchor = mapView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0)
        mapViewTopAnchor.isActive = true
        
        compassView.setAnchors(top: searchView.bottomAnchor, leading: nil, trailing: searchView.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: nil, trailingConstant: 0, bottomConstant: nil)
        
        locationButton.setAnchors(top: nil, leading: nil, trailing: trailingAnchor, bottom: removeButton.topAnchor, topConstant: nil, leadingConstant: nil, trailingConstant: 20, bottomConstant: 20)
        locationButton.setAnchorSize(width: 40, height: 40)
        
        removeButton.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        removeButton.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.1)
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.setAnchors(top: removeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        
        searchView.setAnchors(top: mapView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: nil)
        searchView.setAnchorSize(width: nil, height: 50)
        
        searchIconImageView.setAnchors(top: nil, leading: nil, trailing: searchView.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 10, bottomConstant: nil)
        searchIconImageView.setAnchorSize(width: 20, height: 20)
        searchIconImageView.center(toVertically: searchView, toHorizontally: nil)
        
        searchField.setAnchors(top: searchView.topAnchor, leading: searchView.leadingAnchor, trailing: searchIconImageView.leadingAnchor, bottom: searchView.bottomAnchor, topConstant: 8, leadingConstant: 12, trailingConstant: 10, bottomConstant: 8)
        searchField.delegate = self
        addSingleButtonToolbar(textField: searchField, name: "Done", target: self, action: #selector(dismissEditing))
        
        resultsView.setAnchors(top: searchView.bottomAnchor, leading: searchView.leadingAnchor, trailing: searchView.trailingAnchor, bottom: nil, topConstant: 8, leadingConstant: 20, trailingConstant: 20, bottomConstant: nil)
        resultsView.setAnchorSize(width: nil, height: 140)
        resultsTableView.setAnchors(top: resultsView.topAnchor, leading: resultsView.leadingAnchor, trailing: resultsView.trailingAnchor, bottom: resultsView.bottomAnchor, topConstant: 2, leadingConstant: 2, trailingConstant: 2, bottomConstant: 2)
    }
    
    @objc func dismissEditing(){
        endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setEditMode(_ isEdit: Bool){
        if isEdit{
            removeButton.isHidden = true
            titleView.isHidden = false
            searchView.isHidden = false
            
            mapViewTopAnchor.isActive = false
            mapViewTopAnchor = mapView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0)
            mapViewTopAnchor.isActive = true
        }else{
            removeButton.isHidden = false
            titleView.isHidden = true
            searchView.isHidden = true
            resultsView.isHidden = true
            
            mapViewTopAnchor.isActive = false
            mapViewTopAnchor = mapView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
            mapViewTopAnchor.isActive = true
        }
    }

}
