//
//  AppDelegate.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 04..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift
import GooglePlaces
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationDelegate = NotificationDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        notificationDelegate.notificationCenter.delegate = notificationDelegate
        notificationDelegate.requestPermission()
        
        GMSPlacesClient.provideAPIKey("")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
                
        //UserDefaults.standard.set(true, forKey: "onboardDone")
        //UserDefaults.standard.removeObject(forKey: "onboardDone")
        
        if UserDefaults.standard.value(forKey: "onboardDone") == nil{
            window?.rootViewController = WalkthroughVC()
        }else{
            window?.rootViewController = TabBarVC()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UIApplication.shared.applicationIconBadgeNumber = 0
        var badge = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        center.getPendingNotificationRequests { (notificationRequests) in
            center.removeAllPendingNotificationRequests()
            for notificationRequest in notificationRequests{
                let identifier = notificationRequest.identifier
                let trigger = notificationRequest.trigger
                let content = notificationRequest.content
                
                let mutableContent = UNMutableNotificationContent()
                mutableContent.title = content.title
                mutableContent.body = content.body
                mutableContent.sound = content.sound
                mutableContent.userInfo = content.userInfo
                mutableContent.categoryIdentifier = content.categoryIdentifier
                badge += 1
                mutableContent.badge = NSNumber(value: badge)
                
                let newRequest = UNNotificationRequest(identifier: identifier, content: mutableContent, trigger: trigger)
                center.add(newRequest) { (error) in
                    if let error = error{
                        #if DEBUG
                            print(error)
                        #endif
                    }
                }
                
            }
        }
        
        
        UserDefaults.init().setValue(badge, forKey: "notificationCounter")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

