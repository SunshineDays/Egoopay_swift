//
//  WPPasswordPhoneCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPasswordPhoneCellID = "WPPasswordPhoneCellID"

class WPPasswordPhoneCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 0))
        phone_textField.leftView = view
        phone_textField.leftViewMode = .always
        phone_textField.becomeFirstResponder()
        
        phone_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        next_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var phone_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
    
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [phone_textField.text!])
    }
}
