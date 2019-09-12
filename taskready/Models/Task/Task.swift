//
//  Task.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 07..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift
import UserNotifications

class Task: Object{
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var dateReminder: Date?
    @objc dynamic var locationName: String?
    @objc dynamic var address: String?
    dynamic let latitude = RealmOptional<Double>()
    dynamic let longitude = RealmOptional<Double>()
    @objc dynamic var descr: String?
    @objc dynamic var list: TaskList?
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(title: String, dateReminder: Date?, locationName: String?, address: String?, latitude: Double?, longitude: Double?, descr: String?, list: TaskList?){
        self.init()
        self.title = title
        self.dateReminder = dateReminder
        self.locationName = locationName
        self.address = address
        self.latitude.value = latitude
        self.longitude.value = longitude
        self.descr = descr
        self.list = list
    }
    
    func copyValues(newTask: Task){
        title = newTask.title
        dateReminder = newTask.dateReminder
        locationName = newTask.locationName
        address = newTask.address
        latitude.value = newTask.latitude.value
        longitude.value = newTask.longitude.value
        descr = newTask.descr
    }
    
    func updateTaskRealm(updatedTask: Task, handler: @escaping(_ success: Bool)->()){
        do{
            let realm = try Realm()
            try realm.write {
                copyValues(newTask: updatedTask)
            }
            
            handler(true)
            return
        }catch{
            handler(false)
            return
        }
    }
    
    func createNotification(date: Date){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "It's time to complete your task"
        content.sound = .default
        
        if let notificationCounter = UserDefaults.init().value(forKey: "notificationCounter") as? Int{
            content.badge = NSNumber(value: notificationCounter + 1)
            UserDefaults.init().setValue(notificationCounter+1, forKey: "notificationCounter")
        }else{
            content.badge = NSNumber(value: 1)
            UserDefaults.init().setValue(1, forKey: "notificationCounter")
        }
    
        
        if let list = list{
            content.userInfo = ["taskID": identifier, "listID": list.identifier]
        }
        
        let deleteAction = UNNotificationAction(identifier: NotificationAction.Delete.rawValue, title: "Delete", options: [])
        let completeAction = UNNotificationAction(identifier: NotificationAction.Complete.rawValue, title: "Complete", options: [])
        let category = UNNotificationCategory(identifier: CategoryIdentifiers.general.rawValue, actions: [deleteAction, completeAction], intentIdentifiers: [], options: [.customDismissAction])
        center.setNotificationCategories([category])
        content.categoryIdentifier = CategoryIdentifiers.general.rawValue
                
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(hashValue), content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error{
                #if DEBUG
                    print(error)
                #endif
            }
        }
    }
    
    func deleteNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [String(hashValue)])
        center.removePendingNotificationRequests(withIdentifiers: [String(hashValue)])
    }
    
}
