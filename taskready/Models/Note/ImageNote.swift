//
//  ImageNote.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class ImageNote: Object{
    
    @objc dynamic var note: Note? = nil
    @objc dynamic var imageLocation: String?
    
    convenience init(title: String, color: String, imageLocation: String?){
        self.init()
        note = Note(title: title, color: color)
        self.imageLocation = imageLocation
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
    
    func updateNote(updatedNote: ImageNote, handler: @escaping(_ success: Bool)->() ){
        deleteImage()
    
        do{
            let realm = try Realm()
            
            try realm.write {
                note?.title = updatedNote.note?.title ?? ""
                note?.color = updatedNote.note?.color ?? ""
                imageLocation = updatedNote.imageLocation
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
            deleteImage()

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
    
    func deleteImage(){
        let fileManager = FileManager()
        if let imageLocation = imageLocation, let url = URL(string: imageLocation){
            do{
                try fileManager.removeItem(at: url)
            }catch{
                #if DEBUG
                    print("Error deleting file")
                #endif
            }
        }
    }
    
}
