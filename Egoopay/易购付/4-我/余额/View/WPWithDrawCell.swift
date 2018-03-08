//
//  WPWithDrawCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPWithDrawCellID = "WPWithDrawCellID"

class WPWithDrawCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        confirm_button.layer.cornerRadius = WPCornerRadius
        
        money_textField.becomeFirstResponder()
        money_textField.delegate = self
        money_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        
        all_button.addTarget(self, action: #selector(self.allButtonAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var money_textField: UITextField!
    
    @IBOutlet weak var all_button: UIButton!
    
    @IBOutlet weak var tip_label: UILabel!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    var model: WPUserInforModel! = nil {
        didSet {
            tip_label.text = "可提现金额" + String(format: "%.2f", model.avl_balance) + "元"
        }
    }
    
    @objc func allButtonAction() {
        money_textField.text = String(format: "%.2f", model.avl_balance)
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [money_textField.text!])
    }
    
    @objc func textFieldAction(_ textField: UITextField) {
        if textField.text != "" && Float(textField.text!)! > model.avl_balance {
            tip_label.text = "金额已超过可提现金额"
            tip_label.textColor = UIColor.red
        }
        else {
            tip_label.text = "可提现金额" + String(format: "%.2f", model.avl_balance) + "元"
            tip_label.textColor = UIColor.darkGray
        }
        
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [money_textField.text!])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text, range: range, replacementString: string)
    }
}
