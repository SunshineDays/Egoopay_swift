//
//  WPCreditInputInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/9.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPCreditInputInforCellID = "WPCreditInputInforCellID"

class WPCreditInputInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        brank_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        cvv_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        validity_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        confirm_button.layer.cornerRadius = WPCornerRadius

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var credit_label: UILabel!
    
    @IBOutlet weak var deposit_label: UILabel!
    
    @IBOutlet weak var brank_textField: UITextField!
    
    @IBOutlet weak var cvv_textField: UITextField!
    
    @IBOutlet weak var validity_textField: UITextField!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    
    var creditModel: WPBankCardModel! = nil {
        didSet {
            let name = creditModel.bankName
            credit_label.text = name + "信用卡" + "(尾号" + creditModel.lastNumber
        }
    }
    
    var depositModel: WPBankCardModel! = nil {
        didSet {
            let name = depositModel.bankName
            deposit_label.text = name + "储蓄卡" + "(尾号" + depositModel.lastNumber
        }
    }
    
    
    @objc func textFieldAction(_ textField: UITextField) {
        WPInterfaceTool.adjustButtonColor(button: confirm_button, array: [brank_textField.text!, cvv_textField.text!, validity_textField.text!])
        
        switch textField {
        case cvv_textField:
            if (cvv_textField.text?.count)! >= 3 {
                cvv_textField.text = (cvv_textField.text! as NSString).substring(to: 3)
            }
        case validity_textField:
            if (validity_textField.text?.count)! >= 4 {
                validity_textField.text = (validity_textField.text! as NSString).substring(to: 4)
            }

        default:
            break
        }
        
    }
    
}


