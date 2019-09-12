//
//  Event.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 01..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class Event: Object{
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var color = ""
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate: Date?
    @objc dynamic var allDay = false
    @objc dynamic var address: String?
    @objc dynamic var placeName: String?
    dynamic let latitude = RealmOptional<Double>()
    dynamic let longitude = RealmOptional<Double>()
    @objc dynamic var note: String?
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    static func loadEventsRealm(handler: @escaping(_ events: [Event]?) ->() ){
        do{
            let realm = try Realm()
            let events = Array(realm.objects(Event.self))
            
            handler(events)
            return
        }catch{
            handler(nil)
            return
        }
    }
    
    func saveNewEvent(handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            guard let general = realm.object(ofType: General.self, forPrimaryKey: 0) else {
                handler(false)
                return
            }
            
            try realm.write {
                general.eventsCounter += 1
                realm.add(self)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    convenience init(title: String, color: String, startDate: Date, endDate: Date?, allDay: Bool, address: String?, placeName: String?, latitude: Double?, longitude: Double?, note: String?){
        self.init()
        self.title = title
        self.color = color
        self.startDate = startDate
        self.endDate = endDate
        self.allDay = allDay
        self.address = address
        self.placeName = placeName
        self.latitude.value = latitude
        self.longitude.value = longitude
        self.note = note
    }
    
    
    
    func copyValues(newEvent: Event){
        self.title = newEvent.title
        self.color = newEvent.color
        self.startDate = newEvent.startDate
        self.endDate = newEvent.endDate
        self.allDay = newEvent.allDay
        self.address = newEvent.address
        self.placeName = newEvent.placeName
        self.latitude.value = newEvent.latitude.value
        self.longitude.value = newEvent.longitude.value
        self.note = newEvent.note
    }
    
    func updateEventRealm(updatedEvent: Event, handler: @escaping(_ success: Bool)->()){
        do{
            let realm = try Realm()
            try realm.write {
                copyValues(newEvent: updatedEvent)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func deleteEvent(handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            guard let general = realm.object(ofType: General.self, forPrimaryKey: 0) else {
                handler(false)
                return
            }
            
            try realm.write {
                general.eventsCounter -= 1
                realm.delete(self)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
}

