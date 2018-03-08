//
//  WPUserApproveNumberCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPUserApproveNumberCellID = "WPUserApproveNumberCellID"

class WPUserApproveNumberCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        next_button.layer.cornerRadius = WPCornerRadius
        
        name_textField.becomeFirstResponder()
        
        name_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        number_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_textField: UITextField!
    
    @IBOutlet weak var number_textField: UITextField!
    
    @IBOutlet weak var next_button: UIButton!
    
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [name_textField.text!, number_textField.text!])
    }
    
    
    
}
