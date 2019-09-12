//
//  UIViewController+Ext.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround(cancelTouches: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showErrorMessage(){
        let errorVC = UIAlertController(title: "Error", message: "An unexpected error occured!", preferredStyle: .alert)
        errorVC.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        present(errorVC, animated: true, completion: nil)
    }
    
    func openLocationInMaps(latitude: Double, longitude: Double, placeName: String?){
        let alertVC = UIAlertController(title: "Open Location", message: "Would you like to open this location in Maps?", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default, handler: { (_) in
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = placeName
            mapItem.openInMaps(launchOptions: options)
        }))
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            alertVC.addAction(UIAlertAction(title: "Open in Google Maps", style: .default, handler: { (_) in
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            }))
        }
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
