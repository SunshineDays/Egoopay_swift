//
//  WPShopInforInputBCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPShopInforInputBCellID = "WPShopInforInputBCellID"

class WPShopInforInputBCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        next_button.layer.cornerRadius = WPCornerRadius
        
        shopNumber_textField.becomeFirstResponder()
        
        shopNumber_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        fullName_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        idCard_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        email_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var shopNumber_textField: UITextField!
    
    @IBOutlet weak var fullName_textField: UITextField!
    
    @IBOutlet weak var idCard_textField: UITextField!
    
    @IBOutlet weak var email_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
    
    
    @objc func changeNextButtonColorAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [shopNumber_textField.text!, fullName_textField.text!, idCard_textField.text!, email_textField.text!])
    }
    
}
