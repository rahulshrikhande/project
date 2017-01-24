//
//  ReceiptViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 23/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class ReceiptViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var tableView: UITableView!
  
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var valueViaSegue = ""
    var isLoading = false
    var invoices = [DataNameList]()
    var invoiceDetails = DataNameList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        invoiceView.layer.cornerRadius = 3
        fetchInvoiceDetails(InvoiceID: valueViaSegue)
        
    }
    func fetchInvoiceDetails(InvoiceID: String) {
        isLoading = true
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        let parameters: Parameters = [
            "company_code": dbNameStored,
            "invoice_id": InvoiceID
        ]
        
        Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/get_receipt.php", parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                self.invoices = [DataNameList]()
                if let result = response.result.value {
                    let dictionary = result as? NSDictionary
                    print(dictionary!)
                    self.parseInvoiceDetails(dictionary: dictionary as! [String : AnyObject])
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
    func parseInvoiceDetails(dictionary: [String: AnyObject]) {
        
        invoiceNo.text = dictionary["invoice_no"] as? String
        date.text = dictionary["date"] as? String
        customerName.text = dictionary["customer_name"] as? String
        mobileNo.text = dictionary["customer_mobile"] as? String
        amount.text = dictionary["total_amount"] as? String
        balance.text = dictionary["balance"] as? String
        paid.text = dictionary["amount"] as? String
    }
    
    func parseDictionary(dictionary: [String: AnyObject]) -> [DataNameList] {
        guard let array = dictionary["receipt_details"] as? [AnyObject]
            else {
                print("Expected 'result' array")
                return []
        }
        invoices = [DataNameList]()
        
        for resultDict in array {
            var invoice: DataNameList?
            invoice = parseInvoiceTransaction(dictionary: resultDict as! [String : AnyObject])
            if let result = invoice {
                invoices.append(result)
            }
        }
        return invoices
    }
    func parseInvoiceTransaction(dictionary: [String: AnyObject]) -> DataNameList {
        let invoice = DataNameList()
    
        invoice.amount = dictionary["amount"] as! String
        invoice.tranDate = dictionary["tran_date"] as! String
        invoice.paymentType = dictionary["payment_type"] as! String
        invoice.receiptNo = dictionary["receipt_no"] as! String
        return invoice
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ReceiptViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if invoices.count == 0 {
            return 1
        } else {
            return invoices.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDetails", for: indexPath)
        
        if isLoading {
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "Loading..."
            let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if invoices.count == 0 {
            return cell
        } else {
            let invoice = invoices[indexPath.row]
            
            configureForReceiptNo(cell: cell, DataNameList: invoice)
            configureForDate(cell: cell, DataNameList: invoice)
            configureForAmount(cell: cell, DataNameList: invoice)
            return cell
        }
    }
    func configureForReceiptNo(cell: UITableViewCell, DataNameList invoice: DataNameList) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(invoice.receiptNo)"
    }
    func configureForDate(cell: UITableViewCell, DataNameList invoice: DataNameList) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = "\(invoice.tranDate)"
    }
    func configureForAmount(cell: UITableViewCell, DataNameList invoice: DataNameList) {
        let label = cell.viewWithTag(1002) as! UILabel
        label.text = "\(invoice.amount)"
    }
}

