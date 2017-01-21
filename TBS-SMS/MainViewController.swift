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
    
    @IBOutlet weak var todayReceived: UILabel!
    @IBOutlet weak var todaysCancelled: UILabel!
    
    @IBOutlet weak var thisYearReceived: UILabel!
    @IBOutlet weak var thisYearCancelled: UILabel!    
    
    @IBOutlet weak var totalReceived: UILabel!
    @IBOutlet weak var totalOutstanding: UILabel!
    @IBOutlet weak var cancelled: UIButton!
    @IBOutlet weak var cancelledAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // showLoader()
        //Remove Lines from UITabelCell
        self.tableView.separatorStyle = .none
        //Color top Navigation bar to red
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 199/255, green: 53/255, blue: 55/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        cancelled.layer.cornerRadius = 15
        cancelled.isHidden = true
        setupSideMenu()
        
       /* if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }*/
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userLoggedIn = UserDefaults.standard.bool(forKey: "userLoggedIn")
        if !userLoggedIn {
            
            performSegue(withIdentifier: "databaseLogin", sender: self)
        } else {
             self.fetchNumbers()
        }
        
    }
    // Fetch Data
    func fetchNumbers() {
        let userID = UserDefaults.standard.string(forKey: "ID")!
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        
        let parameters: Parameters = [
            "company_code": dbNameStored,
            "user_id": userID,
        ]
       
        Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/get_receivables.php", parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as? NSDictionary
                    let cancelledNumber = Int((JSON?["cancelled"]! as? String)!)
                    if cancelledNumber! > 0 {
                        self.cancelled.isHidden = false
                    }
                    self.todayReceived.text = String(JSON?["today_received"]! as! Double)
                    self.todaysCancelled.text = JSON?["today_cancelled"]! as? String
                    self.thisYearReceived.text = JSON?["financeReceived"]! as? String
                    self.thisYearCancelled.text = JSON?["cancelled"]! as? String
                    self.totalReceived.text = JSON?["received"]! as? String
                    self.totalOutstanding.text = String(format:"%.02f", (JSON?["outstanding"]! as? Float)!)
                    self.cancelled.setTitle(JSON?["cancelled"]! as? String, for: .normal)
                    self.cancelledAmount.text = JSON?["cancelledAmount"]! as? String
                    
                   // self.hideLoader()
                }
            case .failure( _):
                self.alertMessage(message: "Error !!! Unable to connect to Network ")
            }
        }
    
    }
   /* func showLoader() {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10,y:5,width: 50,height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
    
    func hideLoader() {
        dismiss(animated: false, completion: nil)
    }*/
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Network Alert", message: message, preferredStyle: .alert)
        let myaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(myaction)
        present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
       // view.tintColor = UIColor.init(red: 237/255, green: 33/255, blue: 54/255, alpha: 0.5)
        let header = view as! UITableViewHeaderFooterView
        if section == 1 {
            header.textLabel?.textColor = UIColor.black
        } else  if section == 2 {
            header.textLabel?.textColor = UIColor.init(red: 0, green: 157/255, blue: 7/255, alpha: 0.5)
        }
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

