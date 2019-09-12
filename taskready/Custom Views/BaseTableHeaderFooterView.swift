//
//  BaseTableHeaderFooterView.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 18..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class BaseTableHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews(){
        
    }

}
