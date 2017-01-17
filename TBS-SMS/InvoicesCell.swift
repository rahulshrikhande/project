//
//  InvoicesCell.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 17/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

class InvoicesCell: UITableViewCell {
    
    
    @IBOutlet weak var invoiceNumber: UILabel!
    @IBOutlet weak var invoiceDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var balanceAmount: UILabel!
    
    @IBOutlet weak var receipt: UIButton!
    @IBOutlet weak var payNow: UIButton!
    @IBOutlet weak var cancel: UIButton!
   
    override func prepareForReuse() {
        super.prepareForReuse()
        
        invoiceNumber.text =  nil
        invoiceDate.text =  nil
        customerName.text =  nil
        mobileNo.text =  nil
        totalAmount.text =  nil
        paidAmount.text =  nil
        balanceAmount.text =  nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureForInvoicesList(invoices: DataNameList) {
        
        invoiceNumber.text = invoices.invoiceNo
        invoiceDate.text = invoices.date
        customerName.text = invoices.customerName
        mobileNo.text = invoices.customerMobile
        totalAmount.text = invoices.totalAmount
        paidAmount.text = invoices.paidBalance
        balanceAmount.text = invoices.remainBalance
        
    }
    
    
}
