//
//  LoginViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 11/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//kapilharde@gmail.com  pass123


import Foundation
import SideMenu

class SideMenuTableView: UITableViewController {
    
    override func viewDidLoad() {
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
        // Set up a cool background image for demo purposes
      /*  let imageView = UIImageView(image: UIImage(named: "saturn"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        tableView.backgroundView = imageView*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
    }

    @IBAction func logout(_ sender: UIButton) {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
