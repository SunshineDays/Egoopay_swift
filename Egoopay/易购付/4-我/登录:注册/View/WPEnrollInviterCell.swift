//
//  WPEnrollInviterCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPEnrollInviterCellID = "WPEnrollInviterCellID"

class WPEnrollInviterCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        confirm_button.layer.cornerRadius = WPCornerRadius
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 0))
        phone_textField.leftView = view
        phone_textField.leftViewMode = .always
        phone_textField.becomeFirstResponder()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var phone_textField: UITextField!
    
    @IBOutlet weak var confirm_button: UIButton!

    
}
