//
//  HomeVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {

    var mainView: HomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        General.loadGeneral { (eventsCounter, tasksCounter, notesCounter, completedCounter) in
            self.mainView.eventsCounterLabel.text = "\(eventsCounter)"
            self.mainView.tasksCounterLabel.text = "\(tasksCounter)"
            self.mainView.notesCounterLabel.text = "\(notesCounter)"
            
            self.mainView.tasksLeftCounterLabel.text = "\(tasksCounter)"
            self.mainView.tasksLeftLabel.text = tasksCounter == 1 ? "TASK LEFT" : "TASKS LEFT"
            self.mainView.tasksCompletedCounterLabel.text = "\(completedCounter)"
            self.mainView.tasksCompletedLabel.text = completedCounter == 1 ? "TASK COMPLETED" : "TASKS COMPLETED"
        }
    }
    
    @objc func notificationActionTapped(_ notification: Notification){
        loadData()
    }

    @objc func tasksTapped(){
        tabBarController?.selectedIndex = 1
    }
    
    @objc func notesTapped(){
        tabBarController?.selectedIndex = 2
    }
    
    @objc func eventsTapped(){
        tabBarController?.selectedIndex = 3
    }
    
    func setups(){
        navigationItem.title = "Dashboard"
        mainView = HomeView()
        self.view = mainView
        
        mainView.tasksSquareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tasksTapped)))
        mainView.notesSquareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notesTapped)))
        mainView.eventsSquareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eventsTapped)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionTapped), name: Notification.Name(rawValue: "notificationActionTapped"), object: nil)
    }
    

}
