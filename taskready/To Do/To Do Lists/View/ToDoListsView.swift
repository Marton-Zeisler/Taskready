//
//  ToDoListsView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class ToDoListsView: BaseView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ToDoListsCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ToDoListsAddCell.self, forCellWithReuseIdentifier: "addCell")
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(collectionView)
        
        collectionView.setAnchors(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: -5)
    }
    
}
