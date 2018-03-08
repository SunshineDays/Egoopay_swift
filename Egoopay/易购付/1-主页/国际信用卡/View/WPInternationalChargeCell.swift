//
//  WPInternationalChargeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPInternationalChargeCellID = "WPInternationalChargeCellID"

class WPInternationalChargeCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirm_button.layer.cornerRadius = WPCornerRadius
        
        money_textField.becomeFirstResponder()
        money_textField.delegate = self
        money_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
                
        cvv_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var money_textField: UITextField!
    
    @IBOutlet weak var validity_button: UIButton!
    
    @IBOutlet weak var cvv_textField: UITextField!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    @objc func textFieldAction(_ textField: UITextField) {
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [money_textField.text!, cvv_textField.text!])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text, range: range, replacementString: string)
    }

}
