//
//  NotesListVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 06. 10..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import RealmSwift
import Floaty

class NotesListVC: BaseViewController {
    
    var mainView: NotesListView!
    var notes = [Any]()
    
    var floattyFrame: CGRect?
    
    lazy var floaty: Floaty = {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49
        let frame = CGRect(x: UIScreen.main.bounds.width - 56 - 20, y: UIScreen.main.bounds.size.height - 56 - tabBarHeight - 12, width: 56, height: 56)
        floattyFrame = frame
    
        let floaty = Floaty(frame: frame)
        floaty.buttonColor = UIColor(r: 157, g: 146, b: 212, a: 1)
        floaty.plusColor = .white
        floaty.itemSize = 50
        floaty.animationSpeed = 0.05
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.5)
        
        floaty.addItem("Add Note", icon: UIImage(named: "floatyNote"), handler: { (item) in
            let textNoteVC = TextNoteVC()
            textNoteVC.hidesBottomBarWhenPushed = true
            textNoteVC.noteDelegate = self
            self.navigationController?.pushViewController(textNoteVC, animated: true)
        })
        floaty.addItem("Add Image", icon: UIImage(named: "floatyImage"), handler: { (item) in
            let imageNoteVC = ImageNoteVC()
            imageNoteVC.hidesBottomBarWhenPushed = true
            imageNoteVC.noteDelegate = self
            self.navigationController?.pushViewController(imageNoteVC, animated: true)
        })
        floaty.addItem("Add Checklist", icon: UIImage(named: "floatyChecklist"), handler: { (item) in
            let checklistNoteVC = ChecklistNoteVC()
            checklistNoteVC.hidesBottomBarWhenPushed = true
            checklistNoteVC.noteDelegate = self
            self.navigationController?.pushViewController(checklistNoteVC, animated: true)
        })
        floaty.addItem("Add Location", icon: UIImage(named: "floatyLocation"), handler: { (item) in
            let locationNoteVC = LocationNoteVC()
            locationNoteVC.hidesBottomBarWhenPushed = true
            locationNoteVC.noteDelegate = self
            self.navigationController?.pushViewController(locationNoteVC, animated: true)
        })
        
        return floaty
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        loadNotes()
        UIApplication.shared.keyWindow?.addSubview(floaty)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        floaty.isHidden = false
        if let frame = floattyFrame{
            floaty.frame = frame
        }
        floaty.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floaty.isHidden = true
    }
    
    func loadNotes(){
        Note.loadNotesRealm { (notes) in
            if let notes = notes{
                self.notes = notes
                
                if notes.count == 0{
                    self.mainView.tableView.isHidden = true
                    self.mainView.addNoteLabel.isHidden = false
                }else{
                    self.mainView.tableView.reloadData()
                }
            }else{
                self.showErrorMessage()
            }
        }
    }
}

extension NotesListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        if let textNote = note as? TextNote, let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NotesListNoteCell{
            cell.setupData(textNote: textNote)
            return cell
        }else if let checklistNote = note as? ChecklistNote, let cell = tableView.dequeueReusableCell(withIdentifier: "checksCell", for: indexPath) as? NotesListChecksCell{
            cell.setupData(checkNote: checklistNote)
            return cell
        }else if let locationNote = note as? LocationNote, let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? NotesListLocationCell{
            cell.setupData(locationNote: locationNote)
            return cell
        }else if let imageNote = note as? ImageNote, let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? NotesListImageCell{
            cell.setupData(imageNote: imageNote)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let note = notes[indexPath.row]
        
        if let textNote = note as? TextNote{
            // TEXT NOTE CELL
            if let descr = textNote.descr{
                let textFrame = NSString(string: descr).boundingRect(with: CGSize(width: UIScreen.main.bounds.width-47, height: CGFloat.infinity), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: UIFont(name: "Lato-Light", size: 16)!], context: nil)
                let maxHeight = tableView.frame.height * 0.15
                if textFrame.height > maxHeight{
                    return maxHeight + 90
                }else{
                    return textFrame.height + 90
                }
            }else{
                return 80
            }
        }else if let checksNote = note as? ChecklistNote{
            // CHECK LIST CELL
            let itemsCount = checksNote.checklistItems.count
            if itemsCount > 0 {
                if itemsCount >= 4{
                    return (36 * 4) + 90
                }else{
                    return (36 * CGFloat(itemsCount)) + 80
                }
            }else{
                return 80
            }
        }else if let locationNote = note as? LocationNote{
            // LOCATION CELL
            if locationNote.locationName != nil{
                return 115
            }else{
                return 80
            }
        }else if let imageNote = note as? ImageNote{
            // IMAAGE NOTE
            if imageNote.imageLocation != nil{
                return 180
            }else{
                return 80
            }
        }
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes[indexPath.row]
        
        if let textNote = note as? TextNote{
            let textNoteVC = TextNoteVC()
            textNoteVC.textNote = textNote
            textNoteVC.editMode = false
            textNoteVC.noteDelegate = self
            textNoteVC.selectedIndexPath = indexPath
            textNoteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(textNoteVC, animated: true)
        }else if let imageNote = note as? ImageNote{
            let imageNoteVC = ImageNoteVC()
            imageNoteVC.imageNote = imageNote
            imageNoteVC.editMode = false
            imageNoteVC.noteDelegate = self
            imageNoteVC.selectedIndexPath = indexPath
            imageNoteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(imageNoteVC, animated: true)
        }else if let checklistNote = note as? ChecklistNote{
            let checklistNoteVC = ChecklistNoteVC()
            checklistNoteVC.checklistNote = checklistNote
            checklistNoteVC.editMode = false
            checklistNoteVC.noteDelegate = self
            checklistNoteVC.selectedIndexPath = indexPath
            checklistNoteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(checklistNoteVC, animated: true)
        }else if let locationNote = note as? LocationNote{
            let locationNoteVC = LocationNoteVC()
            locationNoteVC.locationNote = locationNote
            locationNoteVC.editMode = false
            locationNoteVC.noteDelegate = self
            locationNoteVC.selectedIndexPath = indexPath
            locationNoteVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(locationNoteVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.deleteNote(indexPath: indexPath)
            success(true)
        }
        
        action.backgroundColor = UIColor(r: 255, g: 38, b: 0, a: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func deleteNote(indexPath: IndexPath){
        let note = notes[indexPath.row]
        if let textNote = note as? TextNote{
            textNote.deleteNote { (success) in
                if success{
                    self.deletedNote(indexPath: indexPath)
                }else{
                    self.showErrorMessage()
                }
            }
        }else if let imageNote = note as? ImageNote{
            imageNote.deleteNote { (success) in
                if success{
                    self.deletedNote(indexPath: indexPath)
                }else{
                    self.showErrorMessage()
                }
            }
        }else if let checklistNote = note as? ChecklistNote{
            checklistNote.deleteNote { (success) in
                if success{
                    self.deletedNote(indexPath: indexPath)
                }else{
                    self.showErrorMessage()
                }
            }
        }else if let locationNote = note as? LocationNote{
            locationNote.deleteNote { (success) in
                if success{
                    self.deletedNote(indexPath: indexPath)
                }else{
                    self.showErrorMessage()
                }
            }
        }
    }
}

extension NotesListVC: NoteDelegate{
    func deletedNote(indexPath: IndexPath?) {
        let index = indexPath?.row ?? notes.count - 1
        notes.remove(at: index)
        if notes.count == 0{
            mainView.tableView.isHidden = true
            mainView.addNoteLabel.isHidden = false
        }
        mainView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func addedNote(note: Any) {
        notes.append(note)
        mainView.tableView.insertRows(at: [IndexPath(row: notes.count-1, section: 0)], with: .fade)
        
        mainView.tableView.isHidden = false
        mainView.addNoteLabel.isHidden = true
        
        mainView.tableView.scrollToRow(at: IndexPath(row: notes.count-1, section: 0), at: .bottom, animated: true)
    }
    
    func changedNote(newNote: Any, indexPath: IndexPath?) {
        let index = indexPath?.row ?? notes.count - 1
        notes[index] = newNote
        
        if let textNote = newNote as? TextNote{
            if let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NotesListNoteCell{
                cell.setupData(textNote: textNote)
                mainView.tableView.beginUpdates()
                mainView.tableView.endUpdates()
            }
        }else if let imageNote = newNote as? ImageNote{
            if let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NotesListImageCell{
                cell.setupData(imageNote: imageNote)
                mainView.tableView.beginUpdates()
                mainView.tableView.endUpdates()
            }
        }else if let checklistNote = newNote as? ChecklistNote{
            if let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NotesListChecksCell{
                cell.setupData(checkNote: checklistNote)
                mainView.tableView.beginUpdates()
                mainView.tableView.endUpdates()
            }
        }else if let locationNote = newNote as? LocationNote{
            if let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? NotesListLocationCell{
                cell.setupData(locationNote: locationNote)
                mainView.tableView.beginUpdates()
                mainView.tableView.endUpdates()
            }
        }
    }
    
}

extension NotesListVC{
    func setups(){
        navigationItem.title = "Quick Notes"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        mainView = NotesListView()
        self.view = mainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

protocol NoteDelegate: class {
    func deletedNote(indexPath: IndexPath?)
    func addedNote(note: Any)
    func changedNote(newNote: Any, indexPath: IndexPath?)
}
