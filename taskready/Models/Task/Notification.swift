//
//  Notification.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 30..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate{
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestPermission(){
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                #if DEBUG
                    print("Authorised")
                #endif
            } else {
                #if DEBUG
                    print("Not Authorised")
                #endif
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // User took action on a notification
        let userInfo = response.notification.request.content.userInfo
        if let listID = userInfo["listID"] as? String, let taskID = userInfo["taskID"] as? String{
            // Task notification
            taskNotified(listID: listID, taskID: taskID, response: response)
        }
        
        completionHandler()
    }
    
    func taskNotified(listID: String, taskID: String, response: UNNotificationResponse){
        TaskList.getListAndTaskFromID(listID: listID, taskID: taskID) { (list, task) in
            if let list = list, let task = task{
                // Task notification
                if response.actionIdentifier == NotificationAction.Delete.rawValue{
                    // Delete Task
                    list.deleteTaskRealm(task: task) { (success) in
                        NotificationCenter.default.post(name: Notification.Name("notificationActionTapped"), object: task, userInfo: ["action": response.actionIdentifier])
                    }
                }else if response.actionIdentifier == NotificationAction.Complete.rawValue{
                    // Complete Task
                    list.completeTaskRealm(task: task, handler: { (success) in
                        NotificationCenter.default.post(name: Notification.Name("notificationActionTapped"), object: task, userInfo: ["action": response.actionIdentifier])
                    })
                }else{
                    // User tapped on notification
                    if let currentTaskVC = UIApplication.topViewController() as? ToDoTaskVC{
                        if currentTaskVC.selectedTask == task{
                            // Notification task is same as current selected task
                            return
                        }
                    }
                    
                    let taskVC = ToDoTaskVC()
                    taskVC.selectedTask = task
                    taskVC.selectedList = list
                    taskVC.selectedTaskOldDate = task.dateReminder
                    taskVC.hidesBottomBarWhenPushed = true
                    
                    if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController{
                        // UPDATE THIS LINE OF CODE IF NEW TAB BAR CHILD IS ADDED
                        if let taskNavigationController = tabBarController.children[1] as? UINavigationController{
                            var containsSelectedList = false
                            for child in taskNavigationController.viewControllers{
                                if child.isKind(of: ToDoListSelectedVC.self){
                                    if let toDoListSelectedVC = child as? ToDoListSelectedVC{
                                        taskVC.toDoTaskDelegate = toDoListSelectedVC
                                        containsSelectedList = true
                                    }
                                }
                            }
                            
                            if containsSelectedList == false{
                                taskNavigationController.setupDefaultBarStyle()
                                
                                if let toDoListsVC = taskNavigationController.viewControllers.first as? ToDoListsVC{
                                    taskVC.toDoTaskDelegate = toDoListsVC
                                }
                            }
                            
                            
                            if tabBarController.selectedIndex != 1{
                                tabBarController.selectedIndex = 1
                            }
                            
                            taskNavigationController.pushViewController(taskVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Notification received while app is in foreground
    
        completionHandler([.alert, .sound, .badge])
    }
    
}


enum NotificationAction: String{
    case Delete = "delete"
    case Complete = "complete"
}

enum CategoryIdentifiers: String{
    case general = "General"
}

