//
//  SelectedProductCell.swift
//  TBS-SMS
//
//  Created by vaibhav deshpande on 20/01/17.
//  Copyright © 2017 TechnoBase IT Solutions Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

class SelectedProductCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
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
    
    
    
}
