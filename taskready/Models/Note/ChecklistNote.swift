//
//  ChecklistNote.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class ChecklistNote: Object{
    
    @objc dynamic var note: Note? = nil
    var checklistItems = List<ChecklistItem>()
    
    convenience init(title: String, color: String, checklistItems: List<ChecklistItem>?){
        self.init()
        note = Note(title: title, color: color)
        if let items = checklistItems{
            for each in items{
                self.checklistItems.append(ChecklistItem(title: each.title, completed: each.completed))
            }
        }
    }

    
    func saveNewNote(handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            guard let general = realm.object(ofType: General.self, forPrimaryKey: 0) else {
                handler(false)
                return
            }
            
            try realm.write {
                general.notesCounter += 1
                realm.add(self)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func updateNote(updatedNote: ChecklistNote, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            
            try realm.write {
                note?.title = updatedNote.note?.title ?? ""
                note?.color = updatedNote.note?.color ?? ""
                checklistItems.removeAll()
                for each in updatedNote.checklistItems{
                    self.checklistItems.append(ChecklistItem(title: each.title, completed: each.completed))
                }
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func deleteNote(handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            guard let general = realm.object(ofType: General.self, forPrimaryKey: 0) else {
                handler(false)
                return
            }
            
            try realm.write {
                if note != nil{
                    realm.delete(note!)
                }
                realm.delete(self)
                general.notesCounter -= 1
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
}
