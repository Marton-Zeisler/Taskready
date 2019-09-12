//
//  NotesListBaseView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class NotesListBaseCell: BaseTableCell {
    
    let sideColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 238, g: 136, b: 136, a: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Title", font: UIFont(name: "Lato-Regular", size: 16), color: .black)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel(text: "June 10", font: UIFont(name: "Lato-Regular", size: 14), color: UIColor(r: 136, g: 136, b: 136, a: 1))
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .clear
        
        let selectionBG = UIView()
        selectionBG.backgroundColor = #colorLiteral(red: 0.9078759518, green: 0.9078759518, blue: 0.9078759518, alpha: 0.2850759846)
        selectedBackgroundView = selectionBG
        
        addSubview(sideColorView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        
        sideColorView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: nil, bottomConstant: 0)
        sideColorView.setAnchorSize(width: 10, height: nil)
        
        titleLabel.setAnchors(top: topAnchor, leading: sideColorView.trailingAnchor, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        titleLabel.setContentHuggingPriority(.init(252), for: .vertical)
        
        dateLabel.setAnchors(top: nil, leading: titleLabel.leadingAnchor, trailing: nil, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 0, trailingConstant: nil, bottomConstant: 8)
        dateLabel.setContentHuggingPriority(.init(252), for: .vertical)
    }
    
    func setData(note: Note){
        titleLabel.text = note.title
        sideColorView.backgroundColor = UIColor(realmString: note.color)
        titleLabel.textColor = UIColor(realmString: note.color)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateLabel.text = dateFormatter.string(from: note.dateModified)
    }
    
}
