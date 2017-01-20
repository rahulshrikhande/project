//
//  UnitDetailViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 16/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

protocol UnitDetailViewControllerDelegate: class {
    func unitDetailViewControllerDidCancel(controller: UnitDetailViewController)
    func unitDetailViewController(controller: UnitDetailViewController, didFinishEditing unit: DataNameList)
    func unitDetailViewController(controller: UnitDetailViewController, didFinishAdding unit: DataNameList)
}
class UnitDetailViewController: UITableViewController {

    var unitToEdit: DataNameList!
    weak var delegate: UnitDetailViewControllerDelegate?
    
    
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBAction func AddUnit() {
        if let unit = unitToEdit {
            unit.title = unitTextField.text!
            
            //send data to list page i:e StudentListViewController
            delegate?.unitDetailViewController(controller: self, didFinishEditing: unit)
        } else {
            //Initialize
            let unit = DataNameList()
            unit.title = unitTextField.text!
            
            //send data to StudentListViewController
            delegate?.unitDetailViewController(controller: self, didFinishAdding: unit)
            let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
            // Add data to server
            let parameters: Parameters = ["company_code": dbNameStored, "title":  unitTextField.text!]
            
            _ = Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/add_unit.php", parameters: parameters)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unit = unitToEdit {
            title = "Edit Unit"
            unitTextField.text = unit.title            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    

}
