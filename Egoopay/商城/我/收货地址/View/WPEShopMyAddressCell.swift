//
//  WPEShopMyAddressCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyAddressCellID = "WPEShopMyAddressCellID"

class WPEShopMyAddressCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        edit_button.layer.cornerRadius = 1
        edit_button.layer.borderWidth = 0.6
        edit_button.layer.borderColor = UIColor.darkGray.cgColor
        
        delete_button.layer.cornerRadius = 1
        delete_button.layer.borderWidth = 0.6
        delete_button.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var phone_label: UILabel!
    
    @IBOutlet weak var address_label: UILabel!
    
    @IBOutlet weak var default_button: UIButton!
    
    @IBOutlet weak var edit_button: UIButton!
    
    @IBOutlet weak var delete_button: UIButton!
    
    var model: WPEShopMyAddressModel! = nil {
        didSet {
            name_label.text = model.firstname
            phone_label.text = model.telephone
            address_label.text = model.country + " " + model.zone_name + " " + model.city + " " + model.address_1
            
            default_button.setImage(model.is_default == 1 ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        }
    }
    
}
