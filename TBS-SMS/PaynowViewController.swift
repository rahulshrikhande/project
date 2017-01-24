//
//  PaynowViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 23/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class PaynowViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var totalPaid: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var payNowTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var chequeNumber: UITextField!
    @IBOutlet weak var paymentType: UISwitch!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var paynowLabel: UILabel!
    @IBOutlet weak var submitPayment: UIButton!
    
    var valueViaSegue = ""
    var isLoading = false
    let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
    let user_id = UserDefaults.standard.string(forKey: "ID")!
    var parameters : Parameters = [:]
    var url = ""
    var function = FunctionLibrary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateUICash()
        changeLabel.text = "Cash"
        submitPayment.layer.cornerRadius = 4
        datePickerTextField.delegate = self
        datePicker.isHidden = true
        fetchInvoiceView(getID: valueViaSegue as AnyObject, condition: "fetchData")
    }
   
    func updateUI(dictionary: [String: AnyObject]) {

        invoiceNo.text = dictionary["invoice_no"] as! String?
        date.text = dictionary["date"] as! String?
        customerName.text = dictionary["customer_name"] as! String?
        mobileNo.text = dictionary["customer_mobile"] as! String?
        totalPaid.text = dictionary["paid_amount"] as! String?
        totalBalance.text = String(format: "%d", (dictionary["balance"] as! Int?)!)
        
    }
    func fetchInvoiceView(getID: AnyObject, condition: String) {
        isLoading = true
        if condition == "fetchData" {
            parameters = [
                "company_code": dbNameStored,
                "invoice_id": getID
            ]
            url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_invoice_view.php"
            
        } else if condition == "updatePayment" {
            parameters = [
                "company_code": dbNameStored,
                "invoice_id": getID,
                "user_id" : user_id,
                "amount" : payNowTextField.text!,
                "cheque_no" : chequeNumber.text!,
                "cheque_date" : datePickerTextField.text!
            ]
            url = "http://www.tbswebhost.in/sms_uat/iosPhp/create_receipt.php"
        }
        Alamofire.request(url, parameters: parameters ).responseJSON { response in
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let dictionary = result as? NSDictionary
                    if condition ==  "updatePayment" {
                        self.function.alertMessage(message: "Payment updated")
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        self.updateUI(dictionary: dictionary as! [String: AnyObject])
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            case .failure( _):
                self.function.alertMessage(message: "Network error! Please try Again. ")
            }
        }
    }
    
    @IBAction func toggleTextField(_ sender: UISwitch) {
        let type = sender.isOn
        if type {
           changeLabel.text = "Cheque"
           updateUICheque()
        } else {
           changeLabel.text = "Cash"
           updateUICash()
        }
    }
    func updateUICash() {
        chequeNumber.isHidden = true
        datePickerTextField.isHidden = true
        dateButton.isHidden = true
        paynowLabel.frame = CGRect(x:30, y:290, width:67, height: 21)
        payNowTextField.frame = CGRect(x:185, y:285, width:174, height: 30)
        submitPayment.frame = CGRect(x:68, y:333, width:238, height: 35)
    }
    func updateUICheque() {
        chequeNumber.isHidden = false
        datePickerTextField.isHidden = false
        dateButton.isHidden = false
        paynowLabel.frame = CGRect(x:30, y:371, width:67, height: 21)
        payNowTextField.frame = CGRect(x:185, y:376, width:174, height: 30)
        submitPayment.frame = CGRect(x:68, y:418, width:238, height: 35)
    }
    @IBAction func submitPayment(_ sender: UIButton) {
        if !payNowTextField.text!.isEmpty {
            fetchInvoiceView(getID: valueViaSegue as AnyObject, condition: "updatePayment")
        } else {
            self.function.alertMessage(message: "Please enter amount")
        }
    }
    // MARK: TextField Delegate
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        datePickerTextField.text = formatter.string(from: sender.date)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        datePickerTextField.resignFirstResponder()
        return true
    }
    // MARK: Helper Methods
    func closekeyboard() {
        self.view.endEditing(true)
    }
    // MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
