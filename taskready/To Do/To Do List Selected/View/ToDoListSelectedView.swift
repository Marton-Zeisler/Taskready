//
//  ToDoListSelectedView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 18..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import Floaty

class ToDoListSelectedView: BaseView {

    let floaty: Floaty = {
        let floaty = Floaty()
        floaty.buttonColor = UIColor(r: 245, g: 105, b: 134, a: 1)
        floaty.plusColor = .white
        floaty.itemSize = 50
        floaty.handleFirstItemDirectly = true
        return floaty
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 70
        tableView.separatorInset = .zero
        tableView.backgroundColor = .clear
        tableView.register(ToDoListSelectedTaskCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ToDoListSelectedHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        
        return tableView
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(floaty)
        
        tableView.fillSuperView()
    }

}
