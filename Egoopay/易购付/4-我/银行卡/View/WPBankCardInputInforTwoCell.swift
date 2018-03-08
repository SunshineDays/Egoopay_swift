//
//  WPBankCardInputInforTwoCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBankCardInputInforTwoCellID = "WPBankCardInputInforTwoCellID"

class WPBankCardInputInforTwoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        phone_textField.text = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)
        
        next_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var type_label: UILabel!
    
    @IBOutlet weak var phone_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
}
