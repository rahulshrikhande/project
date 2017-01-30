//
//  CreateInvoiceController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 16/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire


class CreateInvoiceController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitInvoice: UIButton!
    @IBOutlet weak var amountTextField: UILabel!
    @IBOutlet weak var vatTextField: UILabel!
    @IBOutlet weak var totalAmountTextField: UILabel!
    @IBOutlet weak var roundOfSaleTextField: UILabel!
    @IBOutlet weak var balanceTextField: UILabel!
    @IBOutlet weak var paidAmount: UITextField!
    
    var amount: Float!
    var vat: Float!
    var totalAmount : Float!
    var roundOfSale: Float!
    var balance: Float!
    var para: Parameters = [:]
    
    var isLoading = false
    var parameters: Parameters = [:]
    
    var productInfo = [ProductInfo]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        submitInvoice.layer.cornerRadius = 4
        tableView.rowHeight = 90
        _ = fetchProducts()
        footerData()
    }
    func fetchProducts() -> Bool {
        var fetched = false
        if (DBManager.shared.loadProducts()) != nil {
            self.productInfo = DBManager.shared.loadProducts()!
            self.tableView.reloadData()
            fetched = true
        }
        return fetched
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitInvoice(_ sender: UIButton) {
        
       
        productInfo = DBManager.shared.loadProducts()!
       
        parameters = [
            "customer_name" : customerNameTextField.text!,
            "customer_mobile" : mobileTextField.text!,
            "amount" : amountTextField.text!,
            "vat_amount" : vatTextField.text!,
            "total_amount" : totalAmountTextField.text!,
            "amount_of_sale" : roundOfSaleTextField.text!,
            "balance" : balanceTextField.text!,
            "products":
                [ para ]
        ]
        print(parameters)

    }
    func footerData() {
        amount = 0
        vat = 0.12 //UserDefaults.standard.string(forKey: "VAT")
        
        for product in productInfo {
            amount = Float(product.amount!)! + amount
            para = [
                "serverProductId" : product.product_id,
                "quantity" : product.quantity,
                "unit" : product.unit,
                "amount" : product.amount,
            ]
        }
        print(para)
        amountTextField.text = String(amount)
        vat = vat * amount
        vatTextField.text = String(vat)
        
        totalAmount = amount + vat
        totalAmountTextField.text = String(totalAmount)
        roundOfSaleTextField.text = String(totalAmount)
        balanceTextField.text = String(totalAmount)
    }
}
extension CreateInvoiceController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if productInfo.count == 0 {
            return 0
        } else {
            return productInfo.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if productInfo.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "selectedProduct", for: indexPath)
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedProduct", for: indexPath)
            let product = productInfo[indexPath.row]
            
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "\(product.product_title!)"
            
            let qty = cell.viewWithTag(1001) as! UILabel
            qty.text = "\(product.quantity!)"
            
            let amt = cell.viewWithTag(1002) as! UILabel
            amt.text = "\(product.amount!)"
        
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let product = productInfo[indexPath.row]
        productInfo.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        let result =  DBManager.shared.deleteProduct(withID: product.id)
        if result {
           _ = self.fetchProducts()
            footerData()
        }
    }
}
extension CreateInvoiceController: UITableViewDelegate {
   
}


