//
//  WPBankCardInputNumberCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBankCardInputNumberCellID = "WPBankCardInputNumberCellID"

class WPBankCardInputNumberCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        next_button.layer.cornerRadius = WPCornerRadius
        
        number_textField.becomeFirstResponder()
        number_textField.delegate = self
        number_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var hint_button: UIButton!
    
    @IBOutlet weak var number_textField: UITextField!
    
    @IBOutlet weak var support_button: UIButton!
    
    @IBOutlet weak var next_button: UIButton!
    
    var model: WPUserApproveModel! = nil {
        didSet {
            name_label.text = model.fullName
        }
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [number_textField.text!])
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if ((textField.text?.count)! - 2) % 5 == 0 {
                textField.text = (textField.text! as NSString).substring(to: (textField.text?.count)! - 1)
            }
        }
        else {
            if ((textField.text?.count)! - 0) % 5 == 0 {
                textField.text = textField.text! + " "
            }
        }
        return true
    }
    
    
}
