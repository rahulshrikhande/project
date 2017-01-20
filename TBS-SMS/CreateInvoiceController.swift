//
//  CreateInvoiceController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 16/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class CreateInvoiceController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitInvoice: UIButton!
    
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var vat: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var roundOfSale: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var paidAmount: UITextField!
    
    var products = [DataNameList]()
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        var cellNib = UINib( nibName: TableViewCellIdentifiers.selectedProduct, bundle: nil )
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.selectedProduct)
        
        cellNib = UINib( nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib( nibName: TableViewCellIdentifiers.loadingCell, bundle: nil )
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        

    }
    
    // Before Calling nib its Cell-Identifiers needs to be described here.
    struct TableViewCellIdentifiers {
        static let selectedProduct = "SelectedProduct"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }


    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CreateInvoiceController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if products.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.selectedProduct, for: indexPath) as! SelectedProductCell
       // let product = products[indexPath.row]
       // cell.configureForInvoicesList(invoices: product)
        return cell
    }
}

extension CreateInvoiceController: UITableViewDelegate {
    
}


