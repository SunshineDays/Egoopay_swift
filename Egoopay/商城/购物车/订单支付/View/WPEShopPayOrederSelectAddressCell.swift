//
//  WPEShopPayOrederSelectAddressCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopPayOrederSelectAddressCellID = "WPEShopPayOrederSelectAddressCellID"

class WPEShopPayOrederSelectAddressCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var tel_label: UILabel!
    
    @IBOutlet weak var address_label: UILabel!
    
    var model: WPEShopMyAddressModel! = nil {
        didSet {
            name_label.text = model.firstname
            tel_label.text = model.telephone
            address_label.text = model.country + " " + model.zone_name + " " + model.city + " " + model.address_1
        }
    }
    
    
}
