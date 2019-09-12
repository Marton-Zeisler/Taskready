//
//  AddNewToDoListVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class AddNewToDoListVC: UIViewController {

    var addNewView: AddNewToDoListView!
    
    weak var toDoListDelegate: ToDoListDelegate?
    
    let colors = Statics.colorPickers
    
    let icons = [
        "toDo_0",
        "toDo_1",
        "toDo_2",
        "toDo_3",
        "toDo_4",
        "toDo_5"
    ]
    
    var selectedColorIndex = 0
    var selectedIconIndex = 0
    
    var selectedList: TaskList?
        
    override func viewDidLoad() {
        setups()
    }
    
    @objc func saveTapped(){
        if addNewView.titleField.hasText, let colorString = colors[selectedColorIndex].getRealmColorString(){
            if let list = selectedList{
                // Updating a list
                let title = addNewView.titleField.text!
                let icon = icons[selectedIconIndex]
                let color = colorString
                list.updateListRealm(title: title, icon: icon, color: color) { (success) in
                    if success{
                        self.toDoListDelegate?.updateList(list: list)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showErrorMessage()
                    }
                }
            }else{
                // Creating a new list
                let newList = TaskList(title: addNewView.titleField.text!, icon: icons[selectedIconIndex], color: colorString, tasks: nil)
                newList.createListRealm { (success) in
                    if success{
                        self.toDoListDelegate?.addNewList(taskList: newList)
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        self.showErrorMessage()
                    }
                }
            }
        }else{
            let errorVC = UIAlertController(title: "Incomplete", message: "Please give your new list a name!", preferredStyle: .alert)
            errorVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(errorVC, animated: true, completion: nil)
        }
    }
    
    @objc func deleteTapped(){
        let alertVC = UIAlertController(title: "Confirm your action", message: "Are you sure you want to delete this list?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.deleteList()
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    func deleteList(){
        if let list = selectedList{
            list.deleteTaskListRealm { (success) in
                if success{
                    self.toDoListDelegate?.deletedList(list: list)
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    self.showErrorMessage()
                }
            }
        }else{
            showErrorMessage()
        }
    }
    
}

extension AddNewToDoListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addNewView.colorsCollectionView{
            return colors.count
        }else{
            return icons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == addNewView.colorsCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            
            cell.setColor(color: colors[indexPath.item])
            cell.tickImageView.isHidden = indexPath.item != selectedColorIndex
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as? AddNewToDoListIconCell else {
                return UICollectionViewCell()
            }
            
            cell.setData(color: colors[selectedColorIndex], iconName: icons[indexPath.item])
            cell.selected(indexPath.item == selectedIconIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == addNewView.colorsCollectionView{
            let width = Int((collectionView.frame.width - (10 * 5)) / 6)
            return CGSize(width: width, height: width)
        }else{
            let width = (collectionView.frame.width - (20*3)) / 3.5
            return CGSize(width: width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == addNewView.colorsCollectionView{
            selectedColorIndex = indexPath.item
            addNewView.colorsCollectionView.reloadData()
            addNewView.iconCollectionView.reloadData()
            
            if selectedList != nil{
                // Edit mode
                navigationController?.navigationBar.barTintColor = colors[selectedColorIndex]
            }
        }else{
            selectedIconIndex = indexPath.item
            addNewView.iconCollectionView.reloadData()
        }
    }
}

extension AddNewToDoListVC{
    func setups(){
        addNewView = AddNewToDoListView()
        addNewView.colorsCollectionView.delegate = self
        addNewView.colorsCollectionView.dataSource = self
        addNewView.iconCollectionView.delegate = self
        addNewView.iconCollectionView.dataSource = self
        addNewView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        self.view.addSubview(addNewView)
        addNewView.setAnchors(top: self.view.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        
        self.view.backgroundColor = .white
        hideKeyboardWhenTappedAround(cancelTouches: false)
        
        if let list = selectedList{
            navigationItem.title = "Edit List"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: .done, target: self, action: #selector(deleteTapped))
            addNewView.titleField.text = list.title
            selectedColorIndex = colors.firstIndex(of: UIColor(realmString: list.color)) ?? 0
            selectedIconIndex = icons.firstIndex(of: list.icon) ?? 0
            addNewView.colorsCollectionView.reloadData()
            addNewView.iconCollectionView.reloadData()
        }else{
            navigationItem.title = "Create New List"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNewView.iconCollectionView.scrollToItem(at: IndexPath(item: selectedIconIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if let list = selectedList, list.isInvalidated == false{
            navigationController?.navigationBar.barTintColor = UIColor(realmString: list.color)
        }
    }
    
}
