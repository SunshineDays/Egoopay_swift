//
//  WPEShopMyAddressEditCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyAddressEditCellID = "WPEShopMyAddressEditCellID"

class WPEShopMyAddressEditCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name_textField.becomeFirstResponder()
        confirm_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_textField: UITextField!
    
    @IBOutlet weak var selectLink_button: UIButton!
    
    @IBOutlet weak var phone_textField: UITextField!
    
    @IBOutlet weak var city_label: UILabel!
    @IBOutlet weak var city_button: UIButton!
    
    @IBOutlet weak var address_textField: UITextField!
    
    @IBOutlet weak var code_textField: UITextField!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    
    var model: WPEShopMyAddressModel! = nil {
        didSet {
            name_textField.text = model.firstname
            phone_textField.text = model.telephone
            city_label.text = model.country + " " + model.zone_name + " " + model.city
            address_textField.text = model.address_1
            code_textField.text = model.postcode
        }
    }
    
    
}
