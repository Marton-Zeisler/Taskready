
//
//  EventsListView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 07. 27..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit
import FSCalendar

class EventsListView: BaseView {
    
    let monthTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        return view
    }()
    
    let monthTitleLabel: UILabel = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let label = UILabel(text: dateFormatter.string(from: Date()), font: UIFont(name: "Lato-Medium", size: 18), color: UIColor(r: 70, g: 70, b: 70, a: 1))
        return label
    }()
    
    lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scope = .month
        calendar.select(Date())
        calendar.firstWeekday = 2
        calendar.headerHeight = 0
        calendar.backgroundColor = .clear
        calendar.appearance.weekdayTextColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        calendar.appearance.weekdayFont = UIFont(name: "Lato-Regular", size: 14)
        calendar.appearance.titleFont = UIFont(name: "Lato-Light", size: 17)
        calendar.appearance.selectionColor = UIColor(r: 113, g: 166, b: 220, a: 1)
        calendar.appearance.todayColor = UIColor(r: 70, g: 70, b: 70, a: 1)
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        return calendar
    }()
    var calendarConstraint: NSLayoutConstraint!
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.register(EventsListCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        return tableView
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let barTitleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(monthTitleView)
        monthTitleView.addSubview(monthTitleLabel)
        addSubview(calendarView)
        addSubview(tableView)
    
        addGestureRecognizer(scopeGesture)
        tableView.panGestureRecognizer.require(toFail: scopeGesture)
        
        monthTitleView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        monthTitleView.setAnchorSize(width: nil, height: 50)
        monthTitleLabel.center(toVertically: monthTitleView, toHorizontally: monthTitleView)
        
        calendarView.setAnchors(top: monthTitleView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        calendarConstraint = calendarView.heightAnchor.constraint(equalToConstant: 300)
        calendarConstraint.isActive = true
        
        tableView.setAnchors(top: calendarView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        
    }
}

extension EventsListView: UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -tableView.contentInset.top
        if shouldBegin {
            let velocity = scopeGesture.velocity(in: self)
            if calendarView.scope == .month{
                return velocity.y < 0
            }else if calendarView.scope == .week{
                return velocity.y > 0
            }
        }
        return shouldBegin
    }

}
