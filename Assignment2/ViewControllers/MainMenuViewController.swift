//
//  MainMenuViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 13/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    

}
