//
//  LoginViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 11/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//kapilharde@gmail.com  pass123

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func userLogin(_ sender: UIButton) {
        
        let user = uidTextField.text!
        let password = passwordTextField.text!
        //Fetch Store Company code
        let dbNameStored = UserDefaults.standard.string(forKey: "dbName")!
        
        let parameters: Parameters = [
            "company_code": dbNameStored,
            "email": user,
            "password": password
            ]
        
        Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/login.php", parameters: parameters)
            .authenticate(user: user, password: password)
            .responseJSON { response in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    
                    //storeUserData in local 
                    UserDefaults.standard.set(JSON["id"], forKey: "ID")
                    UserDefaults.standard.set(JSON["company_logo"], forKey: "CompanyLogo")
                    UserDefaults.standard.set(JSON["company_name"], forKey: "CompanyName")
                    UserDefaults.standard.set(JSON["company_address"], forKey: "CompanyAddress")
                }
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.set(true, forKey: "dbLoggedIn")
                self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
