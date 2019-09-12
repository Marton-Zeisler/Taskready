//
//  NotesListLocationCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class NotesListLocationCell: NotesListBaseCell {

    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notesListLocationIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Light", size: 16), color: UIColor(r: 58, g: 58, b: 58, a: 1))
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
    }
    
    func setupData(locationNote: LocationNote){
        super.setData(note: locationNote.note!)
        if let locationName = locationNote.locationName{
            setupLabel()
            locationLabel.text = locationName
        }else{
            locationImageView.removeFromSuperview()
            locationLabel.removeFromSuperview()
        }
    }
    
    func setupLabel(){
        if !locationLabel.isDescendant(of: self){
            addSubview(locationImageView)
            addSubview(locationLabel)
            
            locationImageView.setAnchors(top: super.titleLabel.bottomAnchor, leading: super.titleLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 12, leadingConstant: 0, trailingConstant: nil, bottomConstant: nil)
            locationImageView.setAnchorSize(width: 20, height: 20)
            
            locationLabel.center(toVertically: locationImageView, toHorizontally: nil)
            locationLabel.setAnchors(top: nil, leading: locationImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 8, trailingConstant: 20, bottomConstant: nil)
        }
    }

}
