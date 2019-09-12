//
//  NotesListView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class NotesListView: BaseView{
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.1)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.register(NotesListNoteCell.self, forCellReuseIdentifier: "noteCell")
        tableView.register(NotesListChecksCell.self, forCellReuseIdentifier: "checksCell")
        tableView.register(NotesListImageCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(NotesListLocationCell.self, forCellReuseIdentifier: "locationCell")
        return tableView
    }()
    
    let addNoteLabel: UILabel = {
        let label = UILabel(text: "Add your first note", font: UIFont(name: "Lato-Medium", size: 30), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
        
    override func setupViews() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(addNoteLabel)
        
        tableView.fillSuperView()
        
        addNoteLabel.setAnchors(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: 20, bottomConstant: nil)
        addNoteLabel.center(toVertically: self, toHorizontally: nil)
    }
}
