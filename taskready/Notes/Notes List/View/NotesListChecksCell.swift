//
//  NotesListChecksCell.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import RealmSwift

class NotesListChecksCell: NotesListBaseCell, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.isScrollEnabled = false
        tableview.rowHeight = 40
        tableview.register(NotesListChecksBoxCell.self, forCellReuseIdentifier: "cell")
        tableview.isUserInteractionEnabled = false
        return tableview
    }()
    
    var items = [ChecklistItem]()
    
    override func setupViews() {
        super.setupViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupData(checkNote: ChecklistNote){
        super.setData(note: checkNote.note!)
        let count = checkNote.checklistItems.count
        if count > 0{
            let max = count >= 4 ? 4 : count
            self.items = Array(checkNote.checklistItems[0..<max])
            addTableView()
            tableView.reloadData()
        }else{
            tableView.removeFromSuperview()
        }
    }
    
    func addTableView(){
        if !tableView.isDescendant(of: self){
            addSubview(tableView)
            tableView.setAnchors(top: super.titleLabel.bottomAnchor, leading: super.titleLabel.leadingAnchor, trailing: trailingAnchor, bottom: super.dateLabel.topAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 20, bottomConstant: 10)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NotesListChecksBoxCell else {
            return UITableViewCell()
        }
        
        cell.setupData(item: items[indexPath.row])
        return cell
    }

}

class NotesListChecksBoxCell: BaseTableCell{
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let checkLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont(name: "Lato-Light", size: 16), color: UIColor(r: 58, g: 58, b: 58, a: 1))
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(checkImageView)
        addSubview(checkLabel)
        
        checkImageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 2, leadingConstant: 2, trailingConstant: nil, bottomConstant: nil)
        checkImageView.setAnchorSize(width: 20, height: 20)
        
        checkLabel.center(toVertically: checkImageView, toHorizontally: nil)
        checkLabel.setAnchors(top: nil, leading: checkImageView.trailingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: 12, trailingConstant: 20, bottomConstant: nil)
    }
    
    func setupData(item: ChecklistItem){
        checkLabel.text = item.title
        if item.completed{
            checkImageView.image = UIImage(named: "checkboxOn")
        }else{
            checkImageView.image = UIImage(named: "checkboxOff")
        }
    }
}
