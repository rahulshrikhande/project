//
//  ReceiptViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 23/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
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
    // If touched anywhere on screen, modal dismisses
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
