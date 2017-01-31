//
//  SearchProductsController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 19/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
// productInfo = DBManager.shared.loadProducts()! 
//_ = navigationController?.popViewController(animated: true)

import UIKit
import Alamofire

class SearchProductsController: UIViewController, UITextFieldDelegate, ProductDetailsControllerDelegate {
    
    func addProductDetails(controller: ProductDetailsController) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proceedButton: UIButton!
    
    var productCount  = [ProductInfo]()
    var isLoading = false
    var hasSearched = false
    var products : [ProductInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceedButton.layer.cornerRadius = 4
       
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 199/255, green: 53/255, blue: 55/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        if (DBManager.shared.loadProducts()) != nil {
            self.productCount = DBManager.shared.loadProducts()!
        }
        self.proceedButton.setTitle(String(self.productCount.count), for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
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
            label.text! = "\(product.product_title!)"
        
        return cell
        }
    }
}
//Select TableView cell 
extension SearchProductsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        print(indexPath)
        performSegue(withIdentifier: "enterDetails", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if products.count == 0 || isLoading {
            return nil
        } else {
            print(indexPath)
            return indexPath
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterDetails" {
            let navigationController = segue.destination
            let controller = navigationController as! ProductDetailsController
            controller.delegate = self
            let indexPath = sender as! NSIndexPath
            let product = products[indexPath.row]
            controller.productInfo = product
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
                    self.products = [ProductInfo]()
                    if let result = response.result.value {
                        let dictionary = result as? NSDictionary
                        
                        self.products = self.parseDictionary(dictionary: dictionary as! [String : AnyObject])
                        if (DBManager.shared.loadProducts()) != nil {
                            self.productCount = DBManager.shared.loadProducts()!
                        }
                        DispatchQueue.main.async {
                            self.proceedButton.setTitle(String(self.productCount.count), for: .normal)
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
        
    func parseDictionary(dictionary: [String: AnyObject]) -> [ProductInfo] {
        guard let array = dictionary["product"] as? [AnyObject]
            else {
                print("Expected 'result' array")
                return []
        }
        products = [ProductInfo]()
            
        for resultDict in array {
            var product: ProductInfo!
            product = parseProduct(dictionary: resultDict as! [String : AnyObject])
            if let result = product {
                products.append(result)
            }
        }
        return products
    }
    func parseProduct(dictionary: [String: AnyObject]) -> ProductInfo {
        var product = ProductInfo()
        product.product_id = Int(dictionary["id"] as! String)
        product.product_title = dictionary["title"] as! String
        return product
    }
    
}
