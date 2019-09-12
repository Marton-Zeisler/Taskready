//
//  TaskList.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 07..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class TaskList: Object{
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var icon = ""
    @objc dynamic var color = ""
    var tasks = List<Task>()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(title: String, icon: String, color: String, tasks: List<Task>?) {
        self.init()
        self.title = title
        self.icon = icon
        self.color = color
        if let newTasks = tasks{
            tasks?.append(objectsIn: newTasks)
        }
    }
    
    static func getListAndTaskFromID(listID: String, taskID: String, handler: @escaping(_ list: TaskList?, _ task: Task?)->() ){
        do{
            let realm = try Realm()
            let list = realm.object(ofType: TaskList.self, forPrimaryKey: listID)
            let task = realm.object(ofType: Task.self, forPrimaryKey: taskID)
            handler(list, task)
        }catch{
            handler(nil, nil)
            return
        }
    }
    
    static func getDefaultTaskLists() -> [TaskList]{
        return [
            TaskList(title: "PERSONAL", icon: "toDo_1", color: "93 213 203", tasks: nil),
            TaskList(title: "WORK", icon: "toDo_5", color: "182 167 227", tasks: nil),
            TaskList(title: "MEET", icon: "toDo_4", color: "255 194 123", tasks: nil),
            TaskList(title: "HOME", icon: "toDo_3", color: "176 103 146", tasks: nil),
            TaskList(title: "PRIVATE", icon: "toDo_3", color: "31 107 124", tasks: nil)
        ]
    }
    
    static func loadListsRealm(handler: @escaping(_ lists: Results<TaskList>?)->() ){
        do{
            let realm = try Realm()
            let lists = realm.objects(TaskList.self)
            
            handler(lists)
            return
        }catch{
            handler(nil)
            return
        }
    }
    
    
    func createListRealm(handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func updateListRealm(title: String, icon: String, color: String, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            try realm.write {
                self.title = title
                self.icon = icon
                self.color = color
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func deleteTaskListRealm(handler: @escaping(_ success: Bool)->() ){
        for task in tasks{
            task.deleteNotification()
        }
        
        do{
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
            
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func addNewTaskRealm(task: Task, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            guard let general = realm.object(ofType: General.self, forPrimaryKey: 0) else {
                handler(false)
                return
            }
            
            try realm.write {
                general.tasksCounter += 1
                tasks.append(task)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func deleteTaskRealm(task: Task, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            if let index = tasks.index(of: task), let general = realm.object(ofType: General.self, forPrimaryKey: 0){
                try realm.write {
                    general.tasksCounter -= 1
                    tasks.remove(at: index)
                }
                
                handler(true)
                return
            }else{
                handler(false)
                return
            }
        }catch{
            handler(false)
            return
        }
    }
    
    func completeTaskRealm(task: Task, handler: @escaping(_ success: Bool)->() ){
        do{
            let realm = try Realm()
            if let index = tasks.index(of: task), let general = realm.object(ofType: General.self, forPrimaryKey: 0){
                try realm.write {
                    general.completedCounter += 1
                    general.tasksCounter -= 1
                    tasks.remove(at: index)
                }
                
                handler(true)
                return
            }
        }catch{
            handler(false)
            return
        }
    }
    
    

}
