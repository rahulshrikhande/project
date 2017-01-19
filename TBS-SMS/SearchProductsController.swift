//
//  SearchProductsController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 19/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class SearchProductsController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proceedButton: UIButton!
    var isLoading = false
    var hasSearched = false
    var products = [DataNameList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceedButton.layer.cornerRadius = 4
       
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 199/255, green: 53/255, blue: 55/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
// Table View
extension SearchProductsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if products.count == 0 {
            return 1
        } else {
            return products.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productsList", for: indexPath)
        
        if isLoading {
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "loading..."
            let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if !hasSearched {
            return cell
        } else if products.count == 0  {
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "No Result Found"
            return cell
        } else {
            let product = products[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            label.text! = "\(product.product_title)"
        
        return cell
        }
    }
}
//Select TableView cell 
extension SearchProductsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "enterDetails", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if products.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
}

// Perform Search
extension SearchProductsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        
        if !searchBar.text!.isEmpty {
        isLoading = true
        hasSearched = false
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        let parameters: Parameters = [
                "company_code": dbNameStored,
                "search_value" : searchBar.text!
            ]
        
        Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/get_search_products.php", parameters: parameters ).responseJSON { response in
                
                switch response.result {
                case .success:
                    self.products = [DataNameList]()
                    if let result = response.result.value {
                        let dictionary = result as? NSDictionary
                        
                        self.products = self.parseDictionary(dictionary: dictionary as! [String : AnyObject])
                        
                        DispatchQueue.main.async {
                            self.proceedButton.setTitle(String(self.products.count), for: .normal)
                            self.isLoading = false
                            self.hasSearched = true
                            self.tableView.reloadData()
                        }
                    }
                case .failure( _):
                    print("Error")
                }
            }
        }
    }
        
    func parseDictionary(dictionary: [String: AnyObject]) -> [DataNameList] {
        guard let array = dictionary["product"] as? [AnyObject]
            else {
                print("Expected 'result' array")
                return []
        }
        products = [DataNameList]()
            
        for resultDict in array {
            var product: DataNameList?
            product = parseUnit(dictionary: resultDict as! [String : AnyObject])
            if let result = product {
                products.append(result)
            }
        }
        return products
    }
    func parseUnit(dictionary: [String: AnyObject]) -> DataNameList {
        let product = DataNameList()
            
        product.product_id = dictionary["id"] as! String
        product.product_title = dictionary["title"] as! String
        return product
    }
        
}
