//
//  BaseViewController.swift
//  taskready
//
//  Created by Marton Zeisler on 2019. 05. 06..
//  Copyright © 2019. Teamly Apps. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setupDefaultBarStyle()
    }

    

}
