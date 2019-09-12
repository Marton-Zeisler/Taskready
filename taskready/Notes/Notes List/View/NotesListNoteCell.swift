//
//  NotesListNoteCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class NotesListNoteCell: NotesListBaseCell {

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Lato-Light", size: 16)
        textView.textColor = UIColor(r: 58, g: 58, b: 58, a: 1)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = .zero
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
    }
    
    func setupData(textNote: TextNote){
        super.setData(note: textNote.note!)
        
        if let descr = textNote.descr{
            descriptionTextView.text = descr
            setupTextView()
        }else{
            descriptionTextView.removeFromSuperview()
        }
    }
    
    private func setupTextView(){
        if !descriptionTextView.isDescendant(of: self){
            addSubview(descriptionTextView)
            descriptionTextView.setAnchors(top: super.titleLabel.bottomAnchor, leading: super.titleLabel.leadingAnchor, trailing: trailingAnchor, bottom: super.dateLabel.topAnchor, topConstant: 8, leadingConstant: -3, trailingConstant: 20, bottomConstant: 10)
        }
    }

}
