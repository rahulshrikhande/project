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
        
        let indexPath = IndexPath(row: newRowIndex, section:0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //Save-query for server
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func unitDetailViewController(controller: UnitDetailViewController, didFinishEditing unit: DataNameList) {
        
        if let index = units.index(of: unit) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTitleForCell(cell: cell, DataNameList: unit)
            }
        }
        //update-query for server
        
        dismiss(animated: true, completion: nil)
    
    }
    
    var units = [DataNameList]()
    var hasSearched = false
    var isLoading = false

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
        self.fetchUnitsList()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    func fetchUnitsList() {
        isLoading = true
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        let parameters: Parameters = [
            "company_code": dbNameStored,
            "email": "kapilharde@gmail.com",
            "password": "pass123"
            ]
        
        Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/login.php", parameters: parameters ).responseJSON { response in
            
            switch response.result {
                case .success:
                    self.units = [DataNameList]()
                    if let result = response.result.value {
                        let dictionary = result as? NSDictionary
                       
                        self.units = self.parseDictionary(dictionary: dictionary as! [String : AnyObject])
                        
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                }
                    case .failure( _):
                            print("Errorg")
            }
        }
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
        units.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        
    }
    func configureTitleForCell(cell: UITableViewCell, DataNameList unit: DataNameList) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(unit.title)"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
