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
       /* if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }*/
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        if !userLoggedIn {
            
            performSegue(withIdentifier: "databaseLogin", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func removeUserDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }

}

