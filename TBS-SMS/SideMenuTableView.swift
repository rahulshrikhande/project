//
//  LoginViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 11/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//kapilharde@gmail.com  pass123


import Foundation
import SideMenu
import UIKit



class SideMenuTableView: UITableViewController, InvoicesViewControllerDelegate, MainViewControllerDelegate {
    
    func allInvoices(controller: InvoicesViewController) {
        showPage = "AllInvoices"        
    }
    func cancelInvoices(controller: InvoicesViewController) {
        showPage = "CancelInvoices"
    }
    func shareAppLink(controller: MainViewController) {
        showPage = "Main"
    }
    @IBOutlet weak var companyName: UILabel!
    
    var showPage = ""
    
    override func viewDidLoad() {
        
        companyName.text = UserDefaults.standard.string(forKey: "CompanyName")
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 199/255, green: 53/255, blue: 55/255, alpha:1)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Remove Lines
        self.tableView.separatorStyle = .none
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
        if segue.identifier == "allInvoices" {
            let navigationController = segue.destination
            let controller = navigationController as! InvoicesViewController
            controller.menuDelegate = self
            controller.segueToPerform = "allInvoices"
            
        } else if segue.identifier == "cancelledInvoices" {
            let navigationController = segue.destination
            let controller = navigationController as! InvoicesViewController
            controller.menuDelegate = self
            controller.segueToPerform = "cancelledInvoices"
            
        } else if segue.identifier == "shareApp" {
            let navigationController = segue.destination
            let controller = navigationController as! MainViewController
            controller.delegate = self
            controller.shareApp = "Yes"
            print(controller.shareApp)
        }
    }

    @IBAction func shareApp(_ sender: Any) {
        
        let message = "Message goes here."
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func logout(_ sender: UIButton) {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            
            performSegue(withIdentifier: "logout", sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
