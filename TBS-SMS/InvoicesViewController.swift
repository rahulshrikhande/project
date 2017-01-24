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
    let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
    
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
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.fetchInvoiceData(fetchDataFor: segueToPerform)
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
        
        parameters = [
            "company_code": dbNameStored,
        ]
        if fetchDataFor == "allInvoices"  {
            title = "All Invoices"
             url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_invoice_data.php"
        } else if fetchDataFor == "cancelledInvoices" || fetchDataFor.isEmpty {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        // configure cell button from nib
        // Receipt Button
        cell.receipt.tag = Int(invoiceList.invoice_id)!
        cell.receipt.addTarget(self, action: #selector(InvoicesViewController.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        // Paynow button 
        cell.payNow.tag = Int(invoiceList.invoice_id)!
        cell.payNow.addTarget(self, action: #selector(InvoicesViewController.payNowbuttonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        //Cancel button
        cell.cancel.tag = Int(invoiceList.invoice_id)!
        cell.cancel.addTarget(self, action: #selector(InvoicesViewController.cancelButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        //Pass selected Data to variable
        cell.configureForInvoicesList(invoices: invoiceList)
        return cell
    }
    func buttonTapped(_ sender:UIButton!){
        self.performSegue(withIdentifier: "receipt", sender: sender)
    }
    func payNowbuttonTapped(_ sender:UIButton!){
        self.performSegue(withIdentifier: "paynow", sender: sender)
    }
    func cancelButtonTapped(_ sender:UIButton!){
        let refreshAlert = UIAlertController(title: "Cancel Invoice !!!", message: "Are you Sure ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            // Ok login here
            self.parameters = [
                "company_code" : self.dbNameStored,
                "invoice_id" : sender.tag,
            ]
            self.url = "http://www.tbswebhost.in/sms_uat/iosPhp/cancel_invoice.php"
            
            Alamofire.request(self.url, parameters: self.parameters ).responseJSON { response in
                
                switch response.result {
                case .success:
                    self.showAlertMessage(message: "Invoice Canclled Successfully")
                    self.fetchInvoiceData(fetchDataFor: "allInvoices")
                case .failure( _):
                    self.showAlertMessage(message: "Network not Responding !! Please try Again ")
                }
            }
        }))
        // Cancel Login here
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
        } else if segue.identifier == "receipt" {
            if let destination = segue.destination as? ReceiptViewController {
                if let button:UIButton = sender as! UIButton? {
                    destination.valueViaSegue = String(button.tag)
                }
            }
        } else if segue.identifier == "paynow" {
            if let destination = segue.destination as? PaynowViewController {
                if let button:UIButton = sender as! UIButton? {
                    destination.valueViaSegue = String(button.tag)
                }
            }
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
