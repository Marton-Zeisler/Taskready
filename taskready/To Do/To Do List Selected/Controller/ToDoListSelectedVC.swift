//
//  ToDoListSelectedVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 18..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoListSelectedVC: UIViewController {
    
    var mainView: ToDoListSelectedView!
    
    var headerStrings = ["UPCOMING", "PAST", "SOMEDAYS (NO DATE)"]
    var taskSections = [(tasks: [Task](), hidden: true), (tasks: [Task](), hidden: true), (tasks: [Task](), hidden: true), (tasks: [Task](), hidden: true), (tasks: [Task](), hidden: true)]
    
    var selectedList: TaskList!
    weak var toDoListDelegate: ToDoListDelegate?
    weak var toDoTaskDelegate: ToDoTaskDelegate?
    
    
    override func loadView() {
        setups()
        loadHeaders()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
    }
    
    func loadHeaders(){
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        headerStrings.insert("TODAY, \(dateFormatter.string(from: today).uppercased())", at: 0)
        headerStrings.insert("TOMORROW, \(dateFormatter.string(from: tomorrow ?? Date()).uppercased())", at: 1)
    }
    
    func loadTasks(){
    
        for task in selectedList.tasks{
            let section = getSectionFromDate(date: task.dateReminder)
            taskSections[section].tasks.append(task)
            taskSections[section].hidden = false
        }
        
        mainView.tableView.reloadData()
    }
    
    @objc func editTapped(){
        let editVC = AddNewToDoListVC()
        editVC.selectedList = selectedList
        editVC.toDoListDelegate = toDoListDelegate
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func addTask(){
        let taskVC = ToDoTaskVC()
        taskVC.selectedList = selectedList
        taskVC.toDoTaskDelegate = self
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func getSectionFromDate(date: Date?) -> Int{
        if let date = date{
            if Calendar.current.isDateInToday(date){
                return 0
            }else if Calendar.current.isDateInTomorrow(date){
                return 1
            }else if date > Date() {
                return 2
            }else{
                return 3
            }
        }else{
            return 4
        }
    }
    
    func deleteTask(indexPath: IndexPath){
        let task = taskSections[indexPath.section].tasks[indexPath.row]
        selectedList.deleteTaskRealm(task: task) { (success) in
            if success{
                if task.dateReminder != nil{
                    task.deleteNotification()
                }
                self.deleteTask(oldDate: task.dateReminder, task: task, list: self.selectedList)
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    func completeTask(indexPath: IndexPath){
        let task = taskSections[indexPath.section].tasks[indexPath.row]
        selectedList.completeTaskRealm(task: task) { (success) in
            if success{
                if task.dateReminder != nil{
                    task.deleteNotification()
                }
                self.deleteTask(oldDate: task.dateReminder, task: task, list: self.selectedList)
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    @objc func notificationActionTapped(_ notification: Notification){
        if let task = notification.object as? Task{
            deleteTask(oldDate: task.dateReminder, task: task, list: selectedList)
        }
    }
    
}

extension ToDoListSelectedVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(taskSections[section].tasks.count)
        print(taskSections[section].hidden)
        return taskSections[section].hidden ? 0 : taskSections[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ToDoListSelectedTaskCell else {
            return UITableViewCell()
        }
        
        cell.setupData(task: taskSections[indexPath.section].tasks[indexPath.row], otherDays: indexPath.section == 2 || indexPath.section == 3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ToDoListSelectedHeader else{
            return UIView()
        }
        
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped(sender:))))
        header.sectionIndex = section
        header.titleLabel.text = headerStrings[section]
        if taskSections[section].hidden{
            header.arrowImageView.image = UIImage(named: "downIcon")
        }else{
            header.arrowImageView.image = UIImage(named: "upIcon")
        }
        
        return header
    }
    
    @objc func headerTapped(sender: UITapGestureRecognizer){
        if let headerView = sender.view as? ToDoListSelectedHeader, let sectionIndex = headerView.sectionIndex{
            
            var indexPaths = [IndexPath]()
            for index in 0..<taskSections[sectionIndex].tasks.count{
                indexPaths.append(IndexPath(row: index, section: sectionIndex))
            }
            
            if taskSections[sectionIndex].hidden{
                // Show tasks
                taskSections[sectionIndex].hidden = false
                headerView.arrowImageView.image = UIImage(named: "upIcon")
                mainView.tableView.insertRows(at: indexPaths, with: .fade)
            }else{
                // Hide tasks
                taskSections[sectionIndex].hidden = true
                headerView.arrowImageView.image = UIImage(named: "downIcon")
                mainView.tableView.deleteRows(at: indexPaths, with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskSections[indexPath.section].tasks[indexPath.row]
        let taskVC = ToDoTaskVC()
        taskVC.selectedTask = task
        taskVC.selectedList = selectedList
        taskVC.toDoTaskDelegate = self
        taskVC.selectedTaskOldDate = task.dateReminder
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.deleteTask(indexPath: indexPath)
            success(true)
        }
 
        action.backgroundColor = UIColor(r: 255, g: 38, b: 0, a: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, success) in
            self.completeTask(indexPath: indexPath)
            success(true)
        }
        
        action.backgroundColor = UIColor(r: 16, g: 154, b: 43, a: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == taskSections.count - 1 ? 80 : 0
    }
    
}

extension ToDoListSelectedVC: ToDoTaskDelegate{
    func createTask(task: Task, list: TaskList) {
        let section = getSectionFromDate(date: task.dateReminder)
        taskSections[section].tasks.append(task)
 
        if taskSections[section].hidden{
            // Previous tasks from the section are hidden
            taskSections[section].hidden = false
            var indexPaths = [IndexPath]()
            for index in 0..<taskSections[section].tasks.count{
                indexPaths.append(IndexPath(item: index, section: section))
            }
            
            if let header = mainView.tableView.headerView(forSection: section) as? ToDoListSelectedHeader{
                header.arrowImageView.image = UIImage(named: "upIcon")
            }
            
            mainView.tableView.insertRows(at: indexPaths, with: .fade)
        }else{
            // Previous tasks from the section are shown already
            mainView.tableView.insertRows(at: [IndexPath(item: taskSections[section].tasks.count-1, section: section)], with: .fade)
        }
        
        mainView.tableView.scrollToRow(at: IndexPath(item: taskSections[section].tasks.count-1, section: section), at: .top, animated: true)
        toDoTaskDelegate?.createTask(task: task, list: list)
    }
    
    func deleteTask(oldDate: Date?, task: Task, list: TaskList) {
        let section = getSectionFromDate(date: oldDate)
        if let row = taskSections[section].tasks.firstIndex(of: task){
            taskSections[section].tasks.remove(at: row)
            
            if taskSections[section].tasks.count == 0{
                taskSections[section].hidden = true
                if let header = mainView.tableView.headerView(forSection: section) as? ToDoListSelectedHeader{
                    header.arrowImageView.image = UIImage(named: "downIcon")
                }
            }
            
            mainView.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .fade)
            toDoTaskDelegate?.deleteTask(oldDate: oldDate, task: task, list: list)
        }
    }
    
    func updateTask(oldDate: Date?, task: Task, list: TaskList) {
        let oldSection = getSectionFromDate(date: oldDate)
        let newSection = getSectionFromDate(date: task.dateReminder)
        
        if oldSection == newSection{
            // Task stays in the same section
            if let row = taskSections[oldSection].tasks.firstIndex(of: task){
                taskSections[oldSection].tasks[row] = task
                if let taskCell = mainView.tableView.cellForRow(at: IndexPath(row: row, section: oldSection)) as? ToDoListSelectedTaskCell{
                    taskCell.setupData(task: task)
                }
            }
        }else{
            deleteTask(oldDate: oldDate, task: task, list: list)
            createTask(task: task, list: list)
        }
    }
}

extension ToDoListSelectedVC{
    func setups(){
        mainView = ToDoListSelectedView()
        self.view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.floaty.addItem(icon: nil) { [weak self] (_) in
            self?.addTask()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionTapped), name: Notification.Name(rawValue: "notificationActionTapped"), object: nil)
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(realmString: selectedList.color)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedList.isInvalidated == false{
            title = selectedList.title
            mainView.floaty.buttonColor = UIColor(realmString: selectedList.color)
        }
        
        setupNavigationBar()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.setupDefaultBarStyle()
    }
}

