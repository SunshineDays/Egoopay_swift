//
//  WPPersonalStateCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopPersonalStateCellID = "WPEShopPersonalStateCellID"

class WPEShopPersonalStateCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var waitPay_button: UIButton!
    
    @IBOutlet weak var waitSending_button: UIButton!
    
    @IBOutlet weak var waitDelivery: UIButton!
    
    @IBOutlet weak var haveBeenSigned_buton: UIButton!
        
    @IBOutlet weak var order_button: UIButton!
    
}
