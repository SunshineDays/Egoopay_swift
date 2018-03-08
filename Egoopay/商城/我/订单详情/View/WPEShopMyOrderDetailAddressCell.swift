//
//  WPEShopMyOrderDetailAddressCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyOrderDetailAddressCellID = "WPEShopMyOrderDetailAddressCellID"

class WPEShopMyOrderDetailAddressCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var phone_label: UILabel!
    
    @IBOutlet weak var address_label: UILabel!
    
    @IBOutlet weak var state_label: UILabel!
    
    var model: WPEShopMyOrderDetailModel! = nil {
        didSet {
            name_label.text = model.shipping_firstname
            phone_label.text = model.telephone
            address_label.text = model.shipping_country + " " + model.shipping_zone + " " + model.shipping_city + " " + model.shipping_address_1
            state_label.text = model.order_status
        }
    }
    
}
