//
//  DatabaseLoginViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 11/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class DatabaseLoginViewController: UIViewController {
    
    var correctCredentials = false
    
    @IBOutlet weak var dbnameTextField: UITextField!
    
    @IBAction func continueToLogin(_ sender: UIButton) {
        //Send Data to server
        let dbName = dbnameTextField.text!
        let parameters: Parameters = [
            "company_code": dbName,
            ]
        _ = Alamofire.request("http://www.tbswebhost.in/sms_uat/iosPhp/sign_in.php", parameters: parameters).responseJSON { response in
            //Handle the json response here
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                if JSON["success"] as! String == "1"  {
                    
                    // Store Database Name
                    UserDefaults.standard.set(dbName, forKey: "dbName")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: "userLogin", sender: self)
                }else {
                    self.showAlertMessage()
                }
            }
        }
    }
    
    
    func showAlertMessage() {
        let alert = UIAlertController(title: "Alert", message: "Wrong Company code", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(red: 205/255, green: 0/255, blue: 0, alpha: 1)
        navigationBarAppearace.barTintColor = UIColor(red: 205/255, green: 0/255, blue: 0, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if userLoggedIn {
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
