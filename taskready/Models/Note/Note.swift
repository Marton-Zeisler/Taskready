//
//  Note.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class Note: Object{
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var color = ""
    @objc dynamic var dateModified = Date()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(title: String, color: String){
        self.init()
        self.title = title
        self.color = color
    }
    
    static func loadNotesRealm(handler: @escaping(_ notes: [Any]?)->() ){
        do{
            let realm = try Realm()
            let textNotes = realm.objects(TextNote.self)
            let checklistNotes = realm.objects(ChecklistNote.self)
            let imageNotes = realm.objects(ImageNote.self)
            let locationNotes = realm.objects(LocationNote.self)
            
            var notes = [Any]()
            notes.append(contentsOf: Array(textNotes))
            notes.append(contentsOf: Array(checklistNotes))
            notes.append(contentsOf: Array(imageNotes))
            notes.append(contentsOf: Array(locationNotes))
            
            handler(notes)
            return
        }catch{
            handler(nil)
            return
        }
    }
}
