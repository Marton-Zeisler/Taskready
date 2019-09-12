//
//  ViewEventVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import MapKit

class ViewEventVC: UIViewController {

    var mainView: ViewEventView!
    var event: Event!
    var indexPath: IndexPath?
    
    weak var eventDelegate: EventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.setupDefaultBarStyle()
    }
    
    @objc func locationTapped(){
        if let latitude = event.latitude.value, let longitude = event.longitude.value{
            openLocationInMaps(latitude: latitude, longitude: longitude, placeName: event.placeName)
        }
    }
    
    @objc func removeTapped(){
        let alertVC = UIAlertController(title: "Confirm your action", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            let startDate = self.event.startDate
            let color = UIColor(realmString: self.event.color)
            self.event.deleteEvent { (success) in
                if success{
                    self.eventDelegate?.deletedEvent(indexPath: self.indexPath, startDate: startDate, color: color)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func editTapped(){
        let editVC = CreateEventVC()
        editVC.event = event
        editVC.viewEventDelegate = self
        editVC.editMode = true
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
}

extension ViewEventVC{
    func setups(){
        mainView = ViewEventView()
        mainView.setupData(event: event)
        self.view = mainView
        
        mainView.locationButton.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
        mainView.removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        mainView.editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(realmString: event.color)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}

extension ViewEventVC: ViewEventDelegate{
    func updatedEvent(event: Event, oldDate: Date, oldColor: UIColor) {
        eventDelegate?.changedEvent(newEvent: event, indexPath: indexPath, oldDate: oldDate, oldColor: oldColor)
        self.event = event
        navigationController?.navigationBar.barTintColor = UIColor(realmString: event.color)
        mainView.setupData(event: event)
    }
}

protocol ViewEventDelegate: class{
    func updatedEvent(event: Event, oldDate: Date, oldColor: UIColor)
}
