//
//  PaynowViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 23/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class PaynowViewController: UIViewController {

    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var totalPaid: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var payNowTextField: UITextField!
    
    
    var valueViaSegue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(valueViaSegue)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
