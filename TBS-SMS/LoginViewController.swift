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
        loginBox.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 4
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBox: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
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
                
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
                        //storeUserData in local
                        UserDefaults.standard.set(JSON["id"], forKey: "ID")
                        UserDefaults.standard.set(user, forKey: "Email")
                        UserDefaults.standard.set(JSON["company_logo"], forKey: "CompanyLogo")
                        UserDefaults.standard.set(JSON["company_name"], forKey: "CompanyName")
                        UserDefaults.standard.set(JSON["company_address"], forKey: "CompanyAddress")
                    }
                    UserDefaults.standard.set(true, forKey: "userLoggedIn")
                    UserDefaults.standard.set(true, forKey: "dbLoggedIn")
                    self.dismiss(animated: true, completion: nil)
                case .failure( _):
                    print("Error")
                }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
