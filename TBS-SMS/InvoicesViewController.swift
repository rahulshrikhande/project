//
//  InvoicesViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 16/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class InvoicesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var isLoading = false
    var invoices = [DataNameList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 170
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        var cellNib = UINib( nibName: TableViewCellIdentifiers.invoiceCell, bundle: nil )
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.invoiceCell)
        
        cellNib = UINib( nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib( nibName: TableViewCellIdentifiers.loadingCell, bundle: nil )
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        
        // Do any additional setup after loading the view.
    }
    
    // Before Calling nib its Cell-Identifiers needs to be described here.
    struct TableViewCellIdentifiers {
        static let invoiceCell = "InvoiceCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchInvoiceData() {
    
    }
}

// Extension to TableViewDataSource
extension InvoicesViewController: UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if invoices.count == 0 || isLoading {
            return nil
        }
        else {
            return indexPath
        }
    }

}
