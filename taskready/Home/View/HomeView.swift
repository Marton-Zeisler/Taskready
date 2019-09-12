//
//  HomeView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 08. 08..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class HomeView: BaseView {
    
    let tasksSquareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 245, g: 105, b: 134, a: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let tasksIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "taskWhiteIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tasksSquareTitleLabel: UILabel = {
        return UILabel(text: "To Do Tasks", font: UIFont(name: "Lato-Regular", size: 16), color: .white)
    }()
    
    lazy var tasksIconTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tasksIconImageView, tasksSquareTitleLabel])
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.leading
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 6
        return stack
    }()
    
    let tasksCounterLabel: UILabel = {
        let label = UILabel(text: "0", font: UIFont(name: "Lato-Regular", size: 17), color: .white)
        label.textAlignment = .center
        return label
    }()
    
    let tasksCounterTitleLabel: UILabel = {
        let label = UILabel(text: "Tasks", font: UIFont(name: "Lato-Light", size: 16), color: .white)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tasksCounterStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tasksCounterLabel, tasksCounterTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()
    
    let tasksSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.5
        return view
    }()
    
    let notesSquareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 157, g: 146, b: 212, a: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let notesIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noteWhiteIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let notesSquareTitleLabel: UILabel = {
        return UILabel(text: "Quick Notes", font: UIFont(name: "Lato-Regular", size: 16), color: .white)
    }()
    
    lazy var notesIconTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notesIconImageView, notesSquareTitleLabel])
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.leading
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 6
        return stack
    }()
    
    let notesCounterLabel: UILabel = {
        let label = UILabel(text: "0", font: UIFont(name: "Lato-Regular", size: 17), color: .white)
        label.textAlignment = .center
        return label
    }()
    
    let notesCounterTitleLabel: UILabel = {
        let label = UILabel(text: "Notes", font: UIFont(name: "Lato-Light", size: 16), color: .white)
        label.textAlignment = .center
        return label
    }()
    
    lazy var notesCounterStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [notesCounterLabel, notesCounterTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()
    
    let notesSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.5
        return view
    }()
    
    let eventsSquareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 112, g: 166, b: 220, a: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let eventsIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "eventWhiteIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let eventsSquareTitleLabel: UILabel = {
        return UILabel(text: "Calendar Events", font: UIFont(name: "Lato-Regular", size: 16), color: .white)
    }()
    
    lazy var eventsIconTitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [eventsIconImageView, eventsSquareTitleLabel])
        stack.axis = .vertical
        stack.alignment = UIStackView.Alignment.leading
        stack.distribution = UIStackView.Distribution.equalSpacing
        stack.spacing = 6
        return stack
    }()
    
    let eventsCounterLabel: UILabel = {
        let label = UILabel(text: "0", font: UIFont(name: "Lato-Regular", size: 17), color: .white)
        label.textAlignment = .center
        return label
    }()
    
    let eventsCounterTitleLabel: UILabel = {
        let label = UILabel(text: "Events", font: UIFont(name: "Lato-Light", size: 16), color: .white)
        label.textAlignment = .center
        return label
    }()
    
    lazy var eventsCounterStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [eventsCounterLabel, eventsCounterTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 0
        return stack
    }()
    
    let eventsSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.5
        return view
    }()
    
    lazy var squareStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tasksSquareView, notesSquareView, eventsSquareView])
        stack.axis = .vertical
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.alignment = UIStackView.Alignment.fill
        stack.spacing = 15
        return stack
    }()
    
    let taskStatsLabel: UILabel = {
        return UILabel(text: "Task Statistics", font: UIFont(name: "Lato-Regular", size: 20), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let halfView1: UIView = {
        let view = UIView()
        view.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.addBorder(borderType: .right, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    let halfView2: UIView = {
        let view = UIView()
        view.addBorder(borderType: .top, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        view.addBorder(borderType: .bottom, width: 0.3, color: UIColor.black.withAlphaComponent(0.1))
        return view
    }()
    
    lazy var halfViewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [halfView1, halfView2])
        stack.axis = .horizontal
        stack.alignment = UIStackView.Alignment.fill
        stack.distribution = UIStackView.Distribution.fillEqually
        return stack
    }()
    
    let tasksLeftCounterLabel: UILabel = {
        return UILabel(text: "0", font: UIFont(name: "Lato-Medium", size: 23), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let tasksLeftLabel: UILabel = {
        return UILabel(text: "TASKS LEFT", font: UIFont(name: "Lato-Regular", size: 14), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    lazy var tasksLeftStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tasksLeftCounterLabel, tasksLeftLabel])
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.leading
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    let tasksCompletedCounterLabel: UILabel = {
        return UILabel(text: "0", font: UIFont(name: "Lato-Medium", size: 23), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    let tasksCompletedLabel: UILabel = {
        return UILabel(text: "TASKS COMPLETED", font: UIFont(name: "Lato-Regular", size: 14), color: UIColor(r: 44, g: 44, b: 44, a: 1))
    }()
    
    lazy var tasksCompletedStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tasksCompletedCounterLabel, tasksCompletedLabel])
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.leading
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(squareStackView)
        
        tasksSquareView.addSubview(tasksIconTitleStack)
        tasksSquareView.addSubview(tasksCounterStack)
        tasksSquareView.addSubview(tasksSeperator)
        
        notesSquareView.addSubview(notesIconTitleStack)
        notesSquareView.addSubview(notesCounterStack)
        notesSquareView.addSubview(notesSeperator)
        
        eventsSquareView.addSubview(eventsIconTitleStack)
        eventsSquareView.addSubview(eventsCounterStack)
        eventsSquareView.addSubview(eventsSeperator)
        
        addSubview(taskStatsLabel)
        addSubview(halfViewStack)
        addSubview(tasksLeftStack)
        addSubview(tasksCompletedStack)
    
        
        squareStackView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: nil)
        
        tasksIconImageView.setAnchorSize(to: tasksSquareView, widthMultiplier: nil, heightMultiplier: 0.4)
        tasksIconImageView.widthAnchor.constraint(equalTo: tasksIconImageView.heightAnchor, multiplier: 1).isActive = true
        tasksIconTitleStack.center(toVertically: tasksSquareView, toHorizontally: nil)
        tasksIconTitleStack.setAnchors(top: nil, leading: tasksSquareView.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 30, trailingConstant: nil, bottomConstant: nil)
        tasksCounterStack.center(toVertically: tasksSquareView, toHorizontally: nil)
        tasksCounterStack.setAnchors(top: nil, leading: nil, trailing: tasksSquareView.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 30, bottomConstant: nil)
        tasksSeperator.center(toVertically: tasksSquareView, toHorizontally: nil)
        tasksSeperator.setAnchors(top: tasksSquareView.topAnchor, leading: eventsSeperator.leadingAnchor, trailing: nil, bottom: tasksSquareView.bottomAnchor, topConstant: 20, leadingConstant: 0, trailingConstant: nil, bottomConstant: 20)
        tasksSeperator.setAnchorSize(width: 1, height: nil)
        
        notesIconImageView.setAnchorSize(to: notesSquareView, widthMultiplier: nil, heightMultiplier: 0.4)
        notesIconImageView.widthAnchor.constraint(equalTo: notesIconImageView.heightAnchor, multiplier: 1).isActive = true
        notesIconTitleStack.center(toVertically: notesSquareView, toHorizontally: nil)
        notesIconTitleStack.setAnchors(top: nil, leading: notesSquareView.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 30, trailingConstant: nil, bottomConstant: nil)
        notesCounterStack.center(toVertically: notesSquareView, toHorizontally: nil)
        notesCounterStack.setAnchors(top: nil, leading: nil, trailing: notesSquareView.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 30, bottomConstant: nil)
        notesSeperator.center(toVertically: notesSquareView, toHorizontally: nil)
        notesSeperator.setAnchors(top: notesSquareView.topAnchor, leading: eventsSeperator.leadingAnchor, trailing: nil, bottom: notesSquareView.bottomAnchor, topConstant: 20, leadingConstant: 0, trailingConstant: nil, bottomConstant: 20)
        notesSeperator.setAnchorSize(width: 1, height: nil)
        
        eventsSquareView.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.19)
        eventsIconImageView.setAnchorSize(to: eventsSquareView, widthMultiplier: nil, heightMultiplier: 0.4)
        eventsIconImageView.widthAnchor.constraint(equalTo: eventsIconImageView.heightAnchor, multiplier: 1).isActive = true
        eventsIconTitleStack.center(toVertically: eventsSquareView, toHorizontally: nil)
        eventsIconTitleStack.setAnchors(top: nil, leading: eventsSquareView.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 30, trailingConstant: nil, bottomConstant: nil)
        eventsCounterStack.center(toVertically: eventsSquareView, toHorizontally: nil)
        eventsCounterStack.setAnchors(top: nil, leading: nil, trailing: eventsSquareView.trailingAnchor, bottom: nil, topConstant: nil, leadingConstant: nil, trailingConstant: 30, bottomConstant: nil)
        eventsSeperator.center(toVertically: eventsSquareView, toHorizontally: nil)
        eventsSeperator.setAnchors(top: eventsSquareView.topAnchor, leading: nil, trailing: eventsCounterStack.leadingAnchor, bottom: eventsSquareView.bottomAnchor, topConstant: 20, leadingConstant: nil, trailingConstant: 30, bottomConstant: 20)
        eventsSeperator.setAnchorSize(width: 1, height: nil)
        
        taskStatsLabel.setAnchors(top: squareStackView.bottomAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: 30, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        halfViewStack.setAnchors(top: taskStatsLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, topConstant: 8, leadingConstant: 0, trailingConstant: 0, bottomConstant: nil)
        halfView1.setAnchorSize(to: self, widthMultiplier: nil, heightMultiplier: 0.17)
        tasksLeftStack.setAnchors(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        tasksLeftStack.center(toVertically: halfView1, toHorizontally: nil)
        tasksCompletedStack.setAnchors(top: nil, leading: halfView2.leadingAnchor, trailing: nil, bottom: nil, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: nil)
        tasksCompletedStack.center(toVertically: halfView2, toHorizontally: nil)
        
    }


}
