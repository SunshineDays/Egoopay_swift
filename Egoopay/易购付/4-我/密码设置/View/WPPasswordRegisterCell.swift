//
//  WPPasswordRegisterCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPasswordRegisterCellID = "WPPasswordRegisterCellID"

class WPPasswordRegisterCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 0))
        password_textField.leftView = view
        password_textField.leftViewMode = .always
        password_textField.becomeFirstResponder()
        password_textField.isSecureTextEntry = true
        password_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        confirm_button.layer.cornerRadius = WPCornerRadius
        
        eye_button.addTarget(self, action: #selector(self.eyeButtonAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var password_textField: UITextField!
    
    @IBOutlet weak var eye_button: UIButton!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    var isOpen = false
    
    @objc func eyeButtonAction() {
        isOpen = !isOpen
        eye_button.setImage(isOpen ? #imageLiteral(resourceName: "icon_eyeOpen") : #imageLiteral(resourceName: "icon_eyeClose"), for: .normal)
        password_textField.isSecureTextEntry = !isOpen
    }
    
    var phone: String! = nil {
        didSet {
            title_label.text = "请为您的账号" + phone + "设置一个新密码"
        }
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [password_textField.text!])
    }
    
}
