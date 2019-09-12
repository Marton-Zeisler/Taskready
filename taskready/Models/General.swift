//
//  General.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 07..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class General: Object{
    @objc dynamic var id = 0
    @objc dynamic var eventsCounter = 0
    @objc dynamic var tasksCounter = 0
    @objc dynamic var notesCounter = 0
    @objc dynamic var completedCounter = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func createGeneralRealm(handler: @escaping (_ success: Bool)->()){
        do{
            let realm = try Realm()
            let general = General()
            let tasks = TaskList.getDefaultTaskLists()
            
            try realm.write {
                realm.add(general)
                realm.add(tasks)
            }
            
            UserDefaults.standard.set(true, forKey: "onboardDone")
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    static func loadGeneral(handler: @escaping(_ eventsCounter: Int, _ tasksCounter: Int, _ notesCounter: Int, _ completedCounter: Int)->() ){
        do{
            let realm = try Realm()
            guard let general = realm.object(ofType: General.self, forPrimaryKey: 0) else {
                handler(0,0,0,0)
                return
            }
            
            handler(general.eventsCounter, general.tasksCounter, general.notesCounter, general.completedCounter)
            return
        }catch{
            handler(0,0,0,0)
            return
        }
    }
}
