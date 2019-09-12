//
//  EventsListVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 27..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import FSCalendar
import Floaty

class EventsListVC: BaseViewController {

    var mainView: EventsListView!
    var events = [[Event]]()
    var dateEvents = [String: [UIColor]]()
    
    var floattyFrame: CGRect?
    
    lazy var floaty: Floaty = {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49
        let frame = CGRect(x: UIScreen.main.bounds.width - 56 - 20, y: UIScreen.main.bounds.size.height - 56 - tabBarHeight - 12, width: 56, height: 56)
        floattyFrame = frame
        
        let floaty = Floaty(frame: frame)
        floaty.buttonColor = UIColor(r: 113, g: 166, b: 220, a: 1)
        floaty.plusColor = .white
        floaty.itemSize = 50
        floaty.animationSpeed = 0.05
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.5)
        floaty.handleFirstItemDirectly = true
        
        return floaty
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        loadEvents()
        
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
    
    func loadEvents(){
        Event.loadEventsRealm { (events) in
            if let events = events{
                if events.count > 0{
                    self.sortEvents(events: events)
                }
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    func sortEvents(events: [Event]){
        var events = events
        events.sort { (event1, event2) -> Bool in
            return event1.startDate < event2.startDate
        }
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let today = Date()
        var closestDiffernce = Double.infinity
        var closestSection = 0
        
        for each in events{
            let eachDateDayString = dateFormatter.string(from: each.startDate)
            if var eventsForDate = dateEvents[eachDateDayString]{
                eventsForDate.append(UIColor(realmString: each.color))
                dateEvents[eachDateDayString] = eventsForDate
            }else{
                let newColors = [UIColor(realmString: each.color)]
                dateEvents[eachDateDayString] = newColors
            }
            
            
            if self.events.isEmpty{
                closestDiffernce = abs(today.timeIntervalSince1970 -  each.startDate.timeIntervalSince1970)
                closestSection = 0
                self.events.append([each])
            }else{
                let lastDate = self.events.last!.last!.startDate
                let eachDate = each.startDate
                
                if calendar.isDate(lastDate, inSameDayAs: eachDate){
                    // Last section
                    self.events[self.events.count-1].append(each)
                }else{
                    // New section
                    self.events.append([each])
                    
                    let difference = abs(today.timeIntervalSince1970 -  each.startDate.timeIntervalSince1970)
                    if  difference < closestDiffernce{
                        closestDiffernce = difference
                        closestSection = self.events.count-1
                    }
                }
            }
        }
        
        mainView.tableView.reloadData()
        let header = mainView.tableView.rect(forSection: closestSection)
        mainView.tableView.scrollRectToVisible(header, animated: true)
        mainView.calendarView.reloadData()
    }
    
    @objc func rigthBarTapped(){
        if navigationItem.rightBarButtonItem?.title == "Collapse"{
            navigationItem.rightBarButtonItem?.title = "Expand"
            mainView.calendarView.setScope(.week, animated: true)
        }else{
            navigationItem.rightBarButtonItem?.title = "Collapse"
            mainView.calendarView.setScope(.month, animated: true)
        }
    }
    
    func addEvent(){
        let createVC = CreateEventVC()
        createVC.hidesBottomBarWhenPushed = true
        createVC.eventDelegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    @objc func todayTapped(){
        mainView.calendarView.select(Date(), scrollToDate: true)
        scrollToDate(date: Date())
    }
    
    func scrollToDate(date: Date){
        let calender = Calendar.current
        
        for (section, eventLists) in events.enumerated(){
            if let firstEvent = eventLists.first{
                if calender.isDate(firstEvent.startDate, inSameDayAs: date){
                    let header = mainView.tableView.rect(forSection: section)
                    mainView.tableView.scrollRectToVisible(header, animated: true)
                    break
                }
            }
        }
    }
}

extension EventsListVC{
    func setups(){
        mainView = EventsListView()
        self.view = mainView
        
        mainView.calendarView.delegate = self
        mainView.calendarView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Collapse", style: .done, target: self, action: #selector(rigthBarTapped))
        navigationItem.title = "Calendar Events"
        mainView.monthTitleLabel.text = mainView.barTitleDateFormatter.string(from: mainView.calendarView.currentPage)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(todayTapped))
        
        floaty.addItem(icon: nil) { (_) in
            self.addEvent()
        }
    }
    
}

extension EventsListVC: FSCalendarDelegate, FSCalendarDataSource{
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        mainView.monthTitleLabel.text = mainView.barTitleDateFormatter.string(from: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        mainView.calendarConstraint.isActive = false
        mainView.calendarConstraint.constant = bounds.height
        mainView.calendarConstraint.isActive = true
        mainView.layoutIfNeeded()
        
        if calendar.scope == .month{
            navigationItem.rightBarButtonItem?.title = "Collapse"
        }else{
            navigationItem.rightBarButtonItem?.title = "Expand"
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            mainView.calendarView.setCurrentPage(date, animated: true)
        }
        
        scrollToDate(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        if let colorsForDate = dateEvents[dateFormatter.string(from: date)]{
            cell.numberOfEvents = colorsForDate.count
            cell.preferredEventDefaultColors = Array(Set(colorsForDate))
            cell.preferredEventSelectionColors = Array(Set(colorsForDate))
        }else{
            cell.numberOfEvents = 0
        }
        
        cell.configureAppearance()
    }
    
    
}

extension EventsListVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EventsListCell else {
            return UITableViewCell()
        }
        
        cell.setupData(event: events[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = events[section][0].startDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        var dateString = dateFormatter.string(from: date)
        let calendar = Calendar.current
        
        if calendar.isDate(date, inSameDayAs: Date()){
            dateString = "Today, \(dateString)"
        }else if calendar.isDateInTomorrow(date){
            dateString = "Tomorrow, \(dateString)"
        }else if calendar.isDateInYesterday(date){
            dateString = "Yesterday, \(dateString)"
        }else{
            dateFormatter.dateFormat = "EEEE"
            dateString = "\(dateFormatter.string(from: date).uppercased()), \(dateString)"
        }
        
        let view = UIView()
        view.backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        let label = UILabel(text: dateString, font: UIFont(name: "Lato-Light", size: 17), color: UIColor(r: 44, g: 44, b: 44, a: 1))
        view.addSubview(label)
        label.center(toVertically: view, toHorizontally: view)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewVC = ViewEventVC()
        viewVC.hidesBottomBarWhenPushed = true
        viewVC.event = events[indexPath.section][indexPath.row]
        viewVC.indexPath = indexPath
        viewVC.eventDelegate = self
        navigationController?.pushViewController(viewVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            let startDate = self.events[indexPath.section][indexPath.row].startDate
            let color = UIColor(realmString: self.events[indexPath.section][indexPath.row].color)
            
            self.events[indexPath.section][indexPath.row].deleteEvent(handler: { (success) in
                if success{
                    self.deletedEvent(indexPath: indexPath, startDate: startDate, color: color)
                }else{
                    self.showErrorMessage()
                }
            })
    
            success(true)
        }
        
        action.backgroundColor = UIColor(r: 255, g: 38, b: 0, a: 1)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}

extension EventsListVC: EventDelegate{
    func deletedEvent(indexPath: IndexPath?, startDate: Date, color: UIColor) {
        if let section = indexPath?.section, let row = indexPath?.row{
            removeDateColor(date: startDate, color: color)
            
            events[section].remove(at: row)
            
            if events[section].count == 0{
                events.remove(at: section)
                mainView.tableView.deleteSections([section], with: .fade)
            }else{
                mainView.tableView.reloadSections([section], with: .fade)
            }
            
            mainView.calendarView.reloadData()
        }
    }
    
    func addedEvent(event: Event) {
        let calender = Calendar.current
        
        if events.isEmpty{
            events.append([event])
            mainView.tableView.insertSections([0], with: .fade)
        }else{
            var foundSection = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            
            for (section, eventsList) in events.enumerated(){
                if let firstEvent = eventsList.first{
                    if dateFormatter.date(from: dateFormatter.string(from: event.startDate))! < dateFormatter.date(from: dateFormatter.string(from: firstEvent.startDate))!{
                        events.insert([event], at: section)
                        mainView.tableView.insertSections([section], with: .fade)
                        foundSection = true
                        break
                    }
                    
                    if calender.isDate(event.startDate, inSameDayAs: firstEvent.startDate){
                        events[section].append(event)
                        events[section].sort { (event1, event2) -> Bool in
                            return event1.startDate < event2.startDate
                        }
                        
                        mainView.tableView.reloadSections([section], with: .fade)
                        foundSection = true
                        break
                    }
                }
            }
            
//            if !foundSection{
//                for (section, eventsList) in events.enumerated(){
//                    if let firstEvent = eventsList.first{
//                        if event.startDate < firstEvent.startDate{
//                            events.insert([event], at: section)
//                            mainView.tableView.insertSections([section], with: .fade)
//                            foundSection = true
//                            break
//                        }
//                    }
//                }
//            }
            
            if !foundSection{
                events.append([event])
                mainView.tableView.insertSections([events.count-1], with: .fade)
            }
        }
        
        insertDateColor(date: event.startDate, color: UIColor(realmString: event.color))
        
        mainView.calendarView.reloadData()
    }
    
    func changedEvent(newEvent: Event, indexPath: IndexPath?, oldDate: Date, oldColor: UIColor) {
        if Calendar.current.isDate(newEvent.startDate, inSameDayAs: oldDate){
            mainView.tableView.reloadRows(at: [indexPath!], with: .fade)
            removeDateColor(date: oldDate, color: oldColor)
            insertDateColor(date: newEvent.startDate, color: UIColor(realmString: newEvent.color))
            mainView.calendarView.reloadData()
        }else{
            deletedEvent(indexPath: indexPath, startDate: oldDate, color: oldColor)
            addedEvent(event: newEvent)
        }
    }
    
    func insertDateColor(date: Date, color: UIColor){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        let eachDateDayString = dateFormatter.string(from: date)
        
        if var eventsForDate = dateEvents[eachDateDayString]{
            eventsForDate.append(color)
            dateEvents[eachDateDayString] = eventsForDate
        }else{
            let newColors = [color]
            dateEvents[eachDateDayString] = newColors
        }
    }
    
    func removeDateColor(date: Date, color: UIColor){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date)
        
        if var eventsForDate = dateEvents[dateString] {
            if let indexColor = eventsForDate.firstIndex(of: color){
                eventsForDate.remove(at: indexColor)
                if eventsForDate.isEmpty{
                    dateEvents[dateString] = nil
                }else{
                    dateEvents[dateString] = eventsForDate
                }
            }
        }
    }
}

protocol EventDelegate: class{
    func deletedEvent(indexPath: IndexPath?, startDate: Date, color: UIColor)
    func addedEvent(event: Event)
    func changedEvent(newEvent: Event, indexPath: IndexPath?, oldDate: Date, oldColor: UIColor)
}
