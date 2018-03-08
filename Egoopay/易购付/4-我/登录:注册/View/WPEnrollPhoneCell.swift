//
//  WPEnrollPhoneCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPEnrollPhoneCellID = "WPEnrollPhoneCellID"

class WPEnrollPhoneCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        phone_textField.becomeFirstResponder()
        phone_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        
        agree_button.addTarget(self, action: #selector(self.agreeAction), for: .touchUpInside)
        
        next_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var phone_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
    
    @IBOutlet weak var agree_button: UIButton!
    
    @IBOutlet weak var protocol_button: UIButton!
    
    var isAgree = true
    
    @objc func agreeAction() {
        isAgree = !isAgree
        agree_button.setImage(isAgree ? #imageLiteral(resourceName: "icon_sel_content_s") : #imageLiteral(resourceName: "icon_sel_content_n"), for: .normal)
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [phone_textField.text!])
    }
    
}
