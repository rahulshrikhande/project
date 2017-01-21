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
class UnitDetailViewController: UITableViewController, UITextFieldDelegate {

    var unitToEdit: DataNameList!
    weak var delegate: UnitDetailViewControllerDelegate?
    var url = ""
    var parameters : Parameters = [:]
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBAction func AddUnit() {
        // Update Unit
        if !unitTextField.text!.isEmpty {
            if let unit = unitToEdit {
                unit.title = unitTextField.text!
                delegate?.unitDetailViewController(controller: self, didFinishEditing: unit)
                           }
        // Add Unit
            else {
                //Initialize
                let unit = DataNameList()
                unit.title = unitTextField.text!
                delegate?.unitDetailViewController(controller: self, didFinishAdding: unit)
            }
        } else {
            showAlertMessage(message: "Textfield is required")
        }
    }
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: "Wrong Company code", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
