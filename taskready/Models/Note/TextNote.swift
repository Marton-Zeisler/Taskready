//
//  TextNote.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class TextNote: Object{
    
    @objc dynamic var note: Note? = nil
    @objc dynamic var descr: String?
    
    convenience init(title: String, color: String, descr: String?){
        self.init()
        note = Note(title: title, color: color)
        self.descr = descr
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
    
    func updateNote(updatedNote: TextNote, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            
            try realm.write {
                note?.title = updatedNote.note?.title ?? ""
                note?.color = updatedNote.note?.color ?? ""
                descr = updatedNote.descr
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
