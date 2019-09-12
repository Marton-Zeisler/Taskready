//
//  WalkthroughVC.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 05..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import RealmSwift

class WalkthroughVC: UIViewController{
    
    var walkthroughView: WalkthroughView!
    let imageNames = ["walkthrough0", "walkthrough1", "walkthrough2"]
    let titles = ["CALENDAR EVENTS", "TO DO TASKS", "QUICK NOTES"]
    let descriptions = [
        "Quickly add your events & easy to switch between month & week view.",
        "Task lists help you make the most of your day and get things done.",
        "Quickest way to offload ideas, thoughts, and to-dos without losing focus."
    ]

    override func loadView() {
        setups()
    }
    
    @objc func backTapped(){
        let newPageIndex = walkthroughView.pageControl.currentPage-1
        scrollToPageIndex(index: newPageIndex)
    }
    
    @objc func nextTapped(){
        let newPageIndex = walkthroughView.pageControl.currentPage+1
        
        if newPageIndex == imageNames.count{
            // Get Started
            getStarted()
        }else{
            // Next
            scrollToPageIndex(index: newPageIndex)
        }
    }
    
    func getStarted(){
        General.createGeneralRealm { (success) in
            if success{
                UserDefaults.standard.set(true, forKey: "onboardDone")
                UIApplication.shared.keyWindow?.rootViewController = TabBarVC()
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    func scrollToPageIndex(index: Int){
        walkthroughView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        walkthroughView.updatePageNumber(index: index)
    }

}

extension WalkthroughVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? WalkthroughCell else { return UICollectionViewCell() }
        
        let index = indexPath.item
        cell.setupData(imageName: imageNames[index], title: titles[index], description: descriptions[index])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        walkthroughView.updatePageNumber(index: pageNumber)
    }
}

extension WalkthroughVC{
    func setups(){
        walkthroughView = WalkthroughView()
        self.view = walkthroughView
        walkthroughView.collectionView.delegate = self
        walkthroughView.collectionView.dataSource = self
        walkthroughView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        walkthroughView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
}
