//
//  UpdateVatController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 17/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class UpdateVatController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var vatTextField: UITextField!
    
    var url = ""
    var parameters: Parameters = [:]
    var vat = DataNameList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchVatData(condition: "fetchVatData")
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func update(_ sender: Any) {
        fetchVatData(condition: "UpdateVat")
    }
    func alertMessage() {
        
    }
    func fetchVatData(condition: String) {
        let dbName = UserDefaults.standard.string(forKey: "dbName")
        if condition == "fetchVatData" {
             url = "http://www.tbswebhost.in/sms_uat/iosPhp/get_all_products.php"
            parameters = [
                "company_code": dbName!,
            ]
        }else if condition == "UpdateVat" {
            if !vatTextField.text!.isEmpty {
                url = "http://www.tbswebhost.in/sms_uat/iosPhp/update_vat.php"
                parameters = [
                    "company_code": dbName!,
                    "vat": vatTextField.text!
                ]
            } else {
                self.alertMessage()
            }
        }
        _ = Alamofire.request(url, parameters: parameters).responseJSON { response in
            //Handle the json response here
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let dictionary = result as? NSDictionary
                    let message = dictionary?["message"] as! String
                    if message == "Updated Successfully" {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self.vatTextField.text! = dictionary?["vat"] as! String
                    }
                }
            case .failure( _):
                print("Error")
                }
            }
        }
}
