//
//  WPBenefitsBalanceCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPBenefitsBalanceCellID = "WPBenefitsBalanceCellID"

class WPBenefitsBalanceCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirm_button.layer.cornerRadius = WPCornerRadius
        
        money_textField.becomeFirstResponder()
        money_textField.delegate = self
        money_textField.addTarget(self, action: #selector(self.textFieldAction), for: .editingChanged)
        
        all_button.addTarget(self, action: #selector(self.allButtonAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var money_textField: UITextField!
    
    @IBOutlet weak var all_button: UIButton!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text, range: range, replacementString: string)
    }
    
    @objc func textFieldAction() {
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [money_textField.text!])
    }
    
    @objc func allButtonAction() {
        money_textField.text = money_label.text
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [money_textField.text!])
    }
    
    var model: WPAgencyModel! = nil {
        didSet {
            money_label.text = String(format: "%.2f", model.benefitBalance)
        }
    }
    
}
