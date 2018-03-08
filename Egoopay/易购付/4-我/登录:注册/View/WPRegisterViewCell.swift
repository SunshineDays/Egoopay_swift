//
//  WPRegisterViewCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPRegisterViewCellID = "WPRegisterViewCellID"

class WPRegisterViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) != nil {
            password_textField.becomeFirstResponder()
            account_textField.text = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!
        }
        else {
            account_textField.becomeFirstResponder()
        }
        
        account_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        
        password_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        
        eye_button.addTarget(self, action: #selector(self.eyeButtonAction), for: .touchUpInside)
        
        confirm_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var avater_imageView: UIImageView!
    
    @IBOutlet weak var account_textField: UITextField!
    
    @IBOutlet weak var password_textField: UITextField!
    
    @IBOutlet weak var eye_button: UIButton!
    
    @IBOutlet weak var forget_button: UIButton!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    @IBOutlet weak var enroll_button: UIButton!
    
    var isOpen = false
    
    var textFieldContent = String()
    
    @objc func eyeButtonAction() {
        isOpen = !isOpen
        eye_button.setImage(isOpen ? #imageLiteral(resourceName: "icon_eyeOpen") : #imageLiteral(resourceName: "icon_eyeClose"), for: .normal)
        password_textField.isSecureTextEntry = !isOpen
    }
    
    @objc func textFieldAction(_ textField: UITextField) {
        textFieldContent = textField.text!
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [password_textField.text!, account_textField.text!])
    }

}
