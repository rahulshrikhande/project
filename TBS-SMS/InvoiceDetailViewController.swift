//
//  InvoiceDetailViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 17/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class InvoiceDetailViewController: UIViewController {

    var invoice: DataNameList!
    var itemsList = [DataNameList]()
    var isLoading = false
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var vat: UILabel!
    @IBOutlet weak var roundOfsale: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var cancelledImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchInvoiceView()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        // to recognize gesture for closing the popup
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InvoiceDetailViewController.close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    func updateUI(dictionary: [String: AnyObject]) {
        
        cancelledImage.isHidden = false
        
        companyName.text = UserDefaults.standard.string(forKey: "CompanyName")
        invoiceNo.text = dictionary["invoice_no"] as! String?
        date.text = dictionary["date"] as! String?
        customerName.text = dictionary["customer_name"] as! String?
        mobileNo.text = dictionary["customer_mobile"] as! String?
        subTotal.text = dictionary["amount"] as! String?
        
        paid.text = dictionary["paid_amount"] as! String?
        balance.text = String(format: "%d", (dictionary["balance"] as! Int?)!)
        
        let subtotal = Float((dictionary["amount"] as! String?)!)
        let vatPercent = 0.12 * subtotal!
        let totalsale = subtotal! + vatPercent
        vat.text = String(vatPercent)
        roundOfsale.text = String(totalsale)
        
        if invoice.status != "Cancelled" {
            cancelledImage.isHidden = true
        }
    }
    
    func imageDownload() {
        Alamofire.download("https://httpbin.org/image/png").responseData { response in
            if let data = response.result.value {
                
                self.companyLogo.image = UIImage(named: "Placeholder")
                if let image = UIImage(data: data) {
                    self.companyLogo.image = image
                }
                
            }
        }
    }
    func fetchInvoiceView() {
        
        isLoading = true
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        let parameters: Parameters = [
            "company_code": dbNameStored,
            "invoice_id": invoice.invoice_id
            ]
        
        let url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_invoice_view.php"
       
        Alamofire.request(url, parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                self.itemsList = [DataNameList]()
                if let result = response.result.value {
                    let dictionary = result as? NSDictionary
                    
                    self.itemsList = self.parseDictionary(dictionary: dictionary as! [String : AnyObject])
                    self.updateUI(dictionary: dictionary as! [String: AnyObject])
                    
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
        guard let array = dictionary["invoice_details"] as? [AnyObject]
            else {
                print("Expected 'result' array")
                return []
        }
        itemsList = [DataNameList]()
        
        for resultDict in array {
            var item: DataNameList?
            item = parseInvoice(dictionary: resultDict as! [String : AnyObject])
            if let result = item {
                itemsList.append(result)
            }
        }
        return itemsList
    }
    func parseInvoice(dictionary: [String: AnyObject]) -> DataNameList {
        let itemList = DataNameList()
        
        let pname = dictionary["product_name"]
        itemList.productName = nullToNil(value: pname as AnyObject?) as! String
        itemList.quantity = nullToNil(value: dictionary["quantity"] as AnyObject?) as! String
        itemList.price = nullToNil(value: dictionary["price"] as AnyObject?) as! String
        itemList.unit = nullToNil(value: dictionary["unit"] as AnyObject?) as! String
        
        return itemList
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        
        if value is NSNull {
            return "N/A" as AnyObject?
        } else {
            return value
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension InvoiceDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// For Closing POP up if user taps anywhere on background
extension InvoiceDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

extension InvoiceDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if itemsList.count == 0 {
            return 1
        } else {
            return itemsList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsList", for: indexPath)
       
            if isLoading {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = "loading..."
                let spinner = cell.viewWithTag(101) as! UIActivityIndicatorView
                spinner.startAnimating()
                return cell
            } else if itemsList.count == 0 {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = "No Result Found"
                return cell
            } else {
                let item = itemsList[indexPath.row]
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = "\(item.productName)"
                
                let quantityLabel = cell.viewWithTag(1001) as! UILabel
                quantityLabel.text = "\(item.quantity)"
                
                let amoutLabel = cell.viewWithTag(1002) as! UILabel
                amoutLabel.text = "\(item.price)"
                return cell
            }
    }
}
extension InvoiceDetailViewController: UITableViewDelegate {


}


