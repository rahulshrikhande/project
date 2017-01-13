//
//  ViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 11/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//9860341786 babu123

import UIKit
import Alamofire
import SideMenu

class MainViewController: UITableViewController {

    var userLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove Lines
        self.tableView.separatorStyle = .none
        //Color top Navigation bar to red
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 199/255, green: 53/255, blue: 55/255, alpha: 0.5)
        setupSideMenu()
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
       // view.tintColor = UIColor.init(red: 237/255, green: 33/255, blue: 54/255, alpha: 0.5)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.red
    }
    
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
     //   SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
  //      SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }


    func removeUserDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }

}

