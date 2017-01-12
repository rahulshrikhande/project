//
//  ViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 11/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//9860341786 babu123

import UIKit
import Alamofire

class MainViewController: UIViewController {

    var userLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if !userLoggedIn {
            performSegue(withIdentifier: "databaseLogin", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

