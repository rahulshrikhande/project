//
//  FunctionLibrary.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 24/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

class FunctionLibrary: UIViewController  {
    
    static let shared: FunctionLibrary = FunctionLibrary()

    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
