//
//  WPPasswordAuthCodeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPasswordAuthCodeCellID = "WPPasswordAuthCodeCellID"

class WPPasswordAuthCodeCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authCode_textField.delegate = self
        authCode_textField.becomeFirstResponder()
        authCode_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        next_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var authCode_textField: UITextField!
    
    @IBOutlet weak var again_button: UIButton!
    
    @IBOutlet weak var next_button: UIButton!
    
    var phone: String! = nil {
        didSet {
            title_label.text = "我们已发送验证码到您的手机：" + "\n\n" + WPPublicTool.stringStar(string: phone, headerIndex: 3, footerIndex: 4)
        }
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [authCode_textField.text!])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.count == 0 ? true : ((textField.text?.count)! < 6)
    }

}
