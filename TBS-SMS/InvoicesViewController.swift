//
//  InvoicesViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 16/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

protocol InvoicesViewControllerDelegate: class {
    func allInvoices(controller: InvoicesViewController)
    func cancelInvoices(controller: InvoicesViewController)
}

class InvoicesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    weak var menuDelegate: InvoicesViewControllerDelegate?
    
    var isLoading = false
    var invoices = [DataNameList]()
    var segueToPerform = ""
    var url = ""
    var hasSearched = false
    var parameters: Parameters = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 170
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        var cellNib = UINib( nibName: TableViewCellIdentifiers.invoiceCell, bundle: nil )
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.invoiceCell)
        
        cellNib = UINib( nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib( nibName: TableViewCellIdentifiers.loadingCell, bundle: nil )
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        self.fetchInvoiceData(fetchDataFor: segueToPerform)
        
        // Do any additional setup after loading the view.
    }
  
    // Before Calling nib its Cell-Identifiers needs to be described here.
    struct TableViewCellIdentifiers {
        static let invoiceCell = "InvoicesCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchInvoiceData(fetchDataFor: String) {
        
        isLoading = true
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        parameters = [
            "company_code": dbNameStored,
        ]
        if fetchDataFor == "allInvoices" {
            title = "All Invoices"
             url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_invoice_data.php"
        } else if fetchDataFor == "cancelledInvoices" {
            title = "Cancelled Invoices"
             url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_cancelled_invoice_data.php"
        } else {
            title = "Searched Invoices"
             url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_invoice_data.php"
            parameters = [
                "company_code" : dbNameStored,
                "search_value" : fetchDataFor,
            ]
        }
        Alamofire.request(url, parameters: parameters ).responseJSON { response in
           
            switch response.result {
            case .success:
                self.invoices = [DataNameList]()
                if let result = response.result.value {
                    let dictionary = result as? NSDictionary
                    
                    self.invoices = self.parseDictionary(dictionary: dictionary as! [String : AnyObject])
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                }
            case .failure( _):
                print("Error")
            }
        }
    }
    
    func parseDictionary(dictionary: [String: AnyObject]) -> [DataNameList] {
        guard let array = dictionary["invoices"] as? [AnyObject]
            else {
                print("Expected 'result' array")
                return []
        }
        invoices = [DataNameList]()
        
        for resultDict in array {
            var invoice: DataNameList?
            invoice = parseUnit(dictionary: resultDict as! [String : AnyObject])
            if let result = invoice {
                invoices.append(result)
            }
        }
        return invoices
    }
    func parseUnit(dictionary: [String: AnyObject]) -> DataNameList {
        let invoice = DataNameList()
        
        invoice.invoice_id = dictionary["id"] as! String
        invoice.invoiceNo = dictionary["invoice_no"] as! String
        invoice.customerName = dictionary["customer_name"] as! String
        invoice.customerMobile = dictionary["customer_mobile"] as! String
        invoice.date = dictionary["date"] as! String
        invoice.totalAmount = dictionary["total_amount"] as! String
        invoice.paidBalance = dictionary["paidBalance"] as! String
        invoice.remainBalance = String(dictionary["remainBalance"] as! Float)
        invoice.status = dictionary["status"] as! String
        
        return invoice
    }
}

// Extension to TableViewDataSource
extension InvoicesViewController: UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        }
        else if invoices.count == 0  {
            return 1
        }
        else {
            return invoices.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if invoices.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.invoiceCell, for: indexPath) as! InvoicesCell
        let invoiceList = invoices[indexPath.row]
        cell.configureForInvoicesList(invoices: invoiceList)
        return cell
    }
}

// extension for UITableViewDelegate
extension InvoicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        // Write this to perform seague
        performSegue(withIdentifier: "showDetails", sender: indexPath)
        
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if invoices.count == 0 || isLoading {
            return nil
        }
        else {
            return indexPath
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailViewController = segue.destination
                as! InvoiceDetailViewController
            let indexPath = sender as! NSIndexPath
            let invoice = invoices[indexPath.row]
            detailViewController.invoice = invoice
        }
    }
    
}

// Search Bar Delegate
extension InvoicesViewController: UISearchBarDelegate {

    // This tell that enter was clicked and search was performed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       performSearch()
    }
    
    func performSearch() {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            tableView.reloadData()
            invoices = [DataNameList]()
            hasSearched = true
            let searchText = searchBar.text!
            fetchInvoiceData(fetchDataFor: searchText)
        
        }
    }

}
