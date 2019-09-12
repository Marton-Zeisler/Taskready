//
//  WalkthroughView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class WalkthroughView: BaseView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(WalkthroughCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.black.withAlphaComponent(0.7)
        pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        return pageControl
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BACK", for: .normal)
        button.setTitleColor(UIColor(r: 92, g: 107, b: 192, a: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        button.isHidden = true
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(UIColor(r: 92, g: 107, b: 192, a: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        return button
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(backButton)
        addSubview(nextButton)
        
        collectionView.setAnchors(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: pageControl.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0)
        pageControl.setAnchors(top: nil, leading: nil, trailing: nil, bottom: nextButton.topAnchor, topConstant: nil, leadingConstant: nil, trailingConstant: nil, bottomConstant: 30)
        pageControl.center(toVertically: nil, toHorizontally: self)
        backButton.setAnchors(top: nil, leading: leadingAnchor, trailing: nil, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: 20, trailingConstant: nil, bottomConstant: 20)
        nextButton.setAnchors(top: nil, leading: nil, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: nil, leadingConstant: nil, trailingConstant: 20, bottomConstant: 20)
        
    }
    
    func updatePageNumber(index: Int){
        pageControl.currentPage = index
        backButton.isHidden = index == 0
        
        UIView.performWithoutAnimation {
            nextButton.setTitle(index == 2 ? "GET STARTED" : "NEXT", for: .normal)
            nextButton.layoutIfNeeded()
        }
    }
    
}
