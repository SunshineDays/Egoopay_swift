//
//  WPBankCardInputInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBankCardInputInforCellID = "WPBankCardInputInforCellID"

class WPBankCardInputInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        next_button.layer.cornerRadius = WPCornerRadius
        phone_textField.text = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var type_label: UILabel!
    
    @IBOutlet weak var validity_button: UIButton!
    
    @IBOutlet weak var hint_button: UIButton!
    
    @IBOutlet weak var phone_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
    
}
