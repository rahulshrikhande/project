//
//  ProductDetailsController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 20/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit

protocol ProductDetailsControllerDelegate : class {
    func addProductDetails(controller: ProductDetailsController)
}

struct ProductInfo {
    var product_id: Int!
    var product_title: String!
    var quantity: String!
    var unit: String!
    var amount: String!
}

class ProductDetailsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var addProduct: UIButton!
    @IBOutlet weak var titleTabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var unit = ""
    
    var productInfo : DataNameList!
    weak var delegate: ProductDetailsControllerDelegate?
    
    var pickerDataSource = ["White", "Red", "Green", "Blue"];
    override func viewDidLoad() {
        super.viewDidLoad()
        if let product = productInfo {
            print(product.product_id)
            titleTabel.text = product.product_title
        }
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.isHidden = true
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func showPicker(_ sender: Any) {
        self.pickerView.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Function for Picker Initalize 
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        unit = pickerDataSource[row]
        unitButton.setTitle(pickerDataSource[row], for: .normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func addProduct(_ sender: UIButton) {
        let productID = productInfo.product_id
        let productName = productInfo.product_title
        let quantity = quantityTextField.text
        let amount = amountTextField.text
        let units = self.unit
        
        DBManager.shared.insertData(productID: Int(productID)!, productTitle: productName, quantity: quantity!, unit: units, amount: amount!)
        delegate?.addProductDetails(controller: self)
    }
    
    
}
