//
//  LocationNote.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class LocationNote: Object{
    
    @objc dynamic var note: Note? = nil
    dynamic let latitude = RealmOptional<Double>()
    dynamic let longitude = RealmOptional<Double>()
    @objc dynamic var locationName: String?
    
    convenience init(title: String, color: String, latitude: Double?, longitude: Double?, locationName: String?){
        self.init()
        note = Note(title: title, color: color)
        self.latitude.value = latitude
        self.longitude.value = longitude
        self.locationName = locationName
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
    
    func updateNote(updatedNote: LocationNote, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            
            try realm.write {
                note?.title = updatedNote.note?.title ?? ""
                note?.color = updatedNote.note?.color ?? ""
                latitude.value = updatedNote.latitude.value
                longitude.value = updatedNote.longitude.value
                locationName = updatedNote.locationName
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
