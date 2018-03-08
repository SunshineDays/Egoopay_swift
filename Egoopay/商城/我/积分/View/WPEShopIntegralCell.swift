//
//  WPEShopIntegralCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/15.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopIntegralCellID = "WPEShopIntegralCellID"

class WPEShopIntegralCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var shopName_label: UILabel!
    
    @IBOutlet weak var shopPrice_label: UILabel!
    
    @IBOutlet weak var integral_label: UILabel!
    
    @IBOutlet weak var date_label: UILabel!
}
