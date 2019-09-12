//
//  ToDoListsVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class ToDoListsVC: BaseViewController {
    
    var toDoListsView: ToDoListsView!
    var cellHeight: CGFloat?
    var taskLists = List<TaskList>()
    
    override func loadView() {
        setups()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadTaskLists()
    }
    
    func loadTaskLists(){
        TaskList.loadListsRealm { (newLists) in
            if let lists = newLists{
                self.taskLists.append(objectsIn: lists)
                self.toDoListsView.collectionView.reloadData()
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    @objc func addTapped(){
        showAddNewScreen()
    }
    
    func showAddNewScreen(){
        let addNewVC = AddNewToDoListVC()
        addNewVC.hidesBottomBarWhenPushed = true
        addNewVC.toDoListDelegate = self
        
        navigationController?.pushViewController(addNewVC, animated: true)
    }
    
    func showList(index: Int){
        let selectedVC = ToDoListSelectedVC()
        selectedVC.selectedList = taskLists[index]
        selectedVC.toDoListDelegate = self
        selectedVC.toDoTaskDelegate = self
        selectedVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(selectedVC, animated: true)
    }
    
    @objc func notificationActionTapped(_ notification: Notification){
        if let task = notification.object as? Task, let list = task.list {
            deleteTask(oldDate: task.dateReminder, task: task, list: list)
        }
    }

}

extension ToDoListsVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskLists.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < taskLists.count{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ToDoListsCell else{
                return UICollectionViewCell()
            }
            
            let index = indexPath.item
            cell.setupBorders(index: index)
            cell.setupData(task: taskLists[index])
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as? ToDoListsAddCell else{
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2
        let height = cellHeight ?? calculateCellHeight(height: collectionView.frame.height/3)
        
        return CGSize(width: width, height: height)
    }
    
    func calculateCellHeight(height: CGFloat) -> CGFloat{
        var height = Int(height)
        while !height.isMultiple(of: 3){
            height -= 1
        }
        
        cellHeight = CGFloat(height)
        return CGFloat(height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.item < taskLists.count{
            showList(index: indexPath.item)
        }else{
            showAddNewScreen()
        }
    }
    
}

extension ToDoListsVC: ToDoListDelegate{
    func addNewList(taskList: TaskList) {
        taskLists.append(taskList)
        let indexPath = IndexPath(item: taskLists.count-1, section: 0)
        toDoListsView.collectionView.insertItems(at: [indexPath])
        toDoListsView.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    func deletedList(list: TaskList) {
        if let index = taskLists.index(of: list){
            taskLists.remove(at: index)
            toDoListsView.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func updateList(list: TaskList) {
        if let index = taskLists.index(of: list){
            taskLists[index] = list
            if let cell = toDoListsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ToDoListsCell{
                cell.setupData(task: taskLists[index])
            }
        }
    }
}

extension ToDoListsVC: ToDoTaskDelegate{
    func createTask(task: Task, list: TaskList) {
        updateList(list: list)
    }
    
    func deleteTask(oldDate: Date?, task: Task, list: TaskList) {
        updateList(list: list)
    }
    
    func updateListData(list: TaskList){
        if let index = taskLists.index(of: list){
            if let cell = toDoListsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ToDoListsCell{
                cell.tasksLabel.text = "\(list.tasks.count) Tasks"
            }
        }
    }
}

extension ToDoListsVC{
    func setups(){
        navigationItem.title = "To Do Tasks"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        toDoListsView = ToDoListsView()
        self.view = toDoListsView
        toDoListsView.collectionView.delegate = self
        toDoListsView.collectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            .add, target: self, action: #selector(addTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationActionTapped), name: Notification.Name(rawValue: "notificationActionTapped"), object: nil)
    }

}

protocol ToDoListDelegate: class{
    func addNewList(taskList: TaskList)
    func deletedList(list: TaskList)
    func updateList(list: TaskList)
}

@objc protocol ToDoTaskDelegate: class{
    func createTask(task: Task, list: TaskList)
    @objc optional func updateTask(oldDate: Date?, task: Task, list: TaskList)
    func deleteTask(oldDate: Date?, task: Task, list: TaskList)
}
