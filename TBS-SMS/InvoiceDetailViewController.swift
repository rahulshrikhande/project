//
//  InvoiceDetailViewController.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 17/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import UIKit

class InvoiceDetailViewController: UIViewController {

    var invoice: DataNameList!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var invoiceNo: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var vat: UILabel!
    @IBOutlet weak var roundOfsale: UILabel!
    @IBOutlet weak var paid: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var cancelledImage: UIImageView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        // to recognize gesture for closing the popup
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InvoiceDetailViewController.close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        
        cancelledImage.isHidden = false
        
        companyName.text = UserDefaults.standard.string(forKey: "CompanyName")
        invoiceNo.text = invoice.invoiceNo
        date.text = invoice.date
        customerName.text = invoice.customerName
        mobileNo.text = invoice.customerMobile
        subTotal.text = invoice.amount
        
        if invoice.status != "Cancelled" {
            cancelledImage.isHidden = true
        }
        
    }
    
    func imageDownload() {
        Alamofire.download("https://httpbin.org/image/png").responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
            }
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension InvoiceDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// For Closing POP up if user taps anywhere on background
extension InvoiceDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

extension InvoiceDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsList", for: indexPath)
        
        return cell
        
    }

}


