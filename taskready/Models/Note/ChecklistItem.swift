//
//  Checklist.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class ChecklistItem: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var completed = false
    
    convenience init(title: String, completed: Bool){
        self.init()
        self.title = title
        self.completed = completed
    }
    
}
