//
//  TabBarVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        // Update "Notification.swift" line 70 if new view controller is added to tab bar
        viewControllers = [
            createViewController(controller: HomeVC(), selectedImage: "tab0On", unselectedImage: "tab0Off"),
            createViewController(controller: ToDoListsVC(), selectedImage: "tab2On", unselectedImage: "tab2Off"),
            createViewController(controller: NotesListVC(), selectedImage: "tab3On", unselectedImage: "tab3Off"),
            createViewController(controller: EventsListVC(), selectedImage: "tab1On", unselectedImage: "tab1Off")
        ]
        
        guard let items = tabBar.items else { return }
        
        for index in 0..<items.count{
            items[index].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
    }
    
    



}
