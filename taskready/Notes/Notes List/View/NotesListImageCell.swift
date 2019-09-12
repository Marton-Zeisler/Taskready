//
//  NotesListImageCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class NotesListImageCell: NotesListBaseCell {

    let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkboxOn")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
    }
    
    func setupData(imageNote: ImageNote){
        super.setData(note: imageNote.note!)
        
        if let imageLocation = imageNote.imageLocation{
            setupImageView()
            loadImage(imageLocation: imageLocation)
        }else{
            noteImageView.removeFromSuperview()
        }
    }
    
    func loadImage(imageLocation: String){
        if let url = URL(string: imageLocation){
            let image = UIImage(contentsOfFile: url.path)
            noteImageView.image = image
        }
    }
    
    func setupImageView(){
        if !noteImageView.isDescendant(of: self){
            addSubview(noteImageView)
            noteImageView.setAnchors(top: super.titleLabel.bottomAnchor, leading: super.titleLabel.leadingAnchor, trailing: trailingAnchor, bottom: super.dateLabel.topAnchor, topConstant: 20, leadingConstant: 0, trailingConstant: 20, bottomConstant: 20)
        }
    }
    
}
