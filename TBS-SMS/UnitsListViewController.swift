//
//  UnitsListViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 16/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class UnitsListViewController: UITableViewController, UnitDetailViewControllerDelegate {
    
    func unitDetailViewControllerDidCancel(controller: UnitDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func unitDetailViewController(controller: UnitDetailViewController, didFinishAdding unit: DataNameList) {
        let newRowIndex = units.count
        units.append(unit)
        print(units.count)
        let indexPath = IndexPath(row: newRowIndex, section:0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //Save-query for server
        
        url = "http://www.tbswebhost.in/sms_uat/iosPhp/add_unit.php"
        parameters = ["company_code": dbNameStored, "unit_name":  unit.title]
        _ = Alamofire.request(url, parameters: parameters).responseJSON { response in
            switch response.result {
                
            case .success:
                self.fetchUnitsList(collectType: "fetchData" as AnyObject)
                 _ = self.navigationController?.popViewController(animated: true)
            case .failure( _):
                self.alertMessage(message: "Network Error..!!! Please try again")
            }
        }
    }
    func unitDetailViewController(controller: UnitDetailViewController, didFinishEditing unit: DataNameList) {
        if let index = units.index(of: unit) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTitleForCell(cell: cell, DataNameList: unit)
            }
        }
        //update-query for server
        url = "http://www.tbswebhost.in/sms_uat/iosPhp/update_unit.php"
        parameters = ["company_code": dbNameStored, "unit_name": unit.title, "unit_id": unit.unit_id ]
         _ = Alamofire.request(url, parameters: parameters)
        
        _ = navigationController?.popViewController(animated: true)
    }
    let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
    var units = [DataNameList]()
    var hasSearched = false
    var isLoading = false
    var url = ""
    var parameters: Parameters = [:]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUnit" {
            let navigationController = segue.destination
            let controller = navigationController as! UnitDetailViewController
            controller.delegate = self
        } else if segue.identifier == "editUnit" {
            let navigationController = segue.destination 
            let controller = navigationController as! UnitDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.unitToEdit = units[indexPath.row]
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUnitsList(collectType: "fetchData" as AnyObject)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    func fetchUnitsList(collectType: AnyObject) {
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        if collectType as! String == "fetchData" {
            print(collectType)
            isLoading = true
            url = "http://www.tbswebhost.in/sms_uat/iosPhp/login.php"
            parameters = [
                "company_code": dbNameStored,
                "email": "kapilharde@gmail.com",
                "password": "pass123"
            ]
        } else {
             print(collectType)
            url = "http://www.tbswebhost.in/sms_uat/iosPhp/delete_unit.php"
            parameters = [
                "company_code": dbNameStored,
                "unit_id": collectType
            ]
        }
        Alamofire.request(url, parameters: parameters ).responseJSON { response in
            switch response.result {
                
                case .success:
                    self.units = [DataNameList]()
                    if let result = response.result.value {
                        let dictionary = result as? NSDictionary
                        print(dictionary!)
                        let message = dictionary?["message"] as! String
                        if message == "Deleted Successfully" {
                            self.fetchUnitsList(collectType: "fetchData" as AnyObject)
                            self.alertMessage(message: "Record Deleted")
                        } else {
                            self.units = self.parseDictionary(dictionary: dictionary as! [String : AnyObject])
                            DispatchQueue.main.async {
                                print(self.units.count)
                                self.isLoading = false
                                self.tableView.reloadData()
                            }
                        }
                }
                    case .failure( _):
                            self.alertMessage(message: "Error Connecting to Network !!! Please try again")
            }
        }
    }
    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func parseDictionary(dictionary: [String: AnyObject]) -> [DataNameList] {
        
        guard let array = dictionary["units"] as? [AnyObject]
            else {
                print("Expected 'result' array")
                return []
        }
        units = [DataNameList]()
        
        for resultDict in array {
           var unit: DataNameList?
           unit = parseUnit(dictionary: resultDict as! [String : AnyObject])
            if let result = unit {
                    units.append(result)
            }
        }
        return units
    }
    func parseUnit(dictionary: [String: AnyObject]) -> DataNameList {
        let unit = DataNameList()
        
        unit.unit_id = dictionary["id"] as! String
        unit.title = dictionary["title"] as! String
        return unit
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isLoading {
            return 1
        } else if units.count == 0 {
            return 1
        } else {
            return units.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitsList", for: indexPath)
        if isLoading {
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "loading..."
            let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if units.count == 0 {
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "No Result Found"
            return cell
        } else {
            let unit = units[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "\(unit.title)"
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let unit = units[indexPath.row]
        units.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        fetchUnitsList(collectType: unit.unit_id as AnyObject)
    }
    func configureTitleForCell(cell: UITableViewCell, DataNameList unit: DataNameList) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(unit.title)"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
