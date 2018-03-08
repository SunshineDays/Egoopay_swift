//
//  WPAppRechargeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/7.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPAppRechargeCellID = "WPAppRechargeCellID"

class WPAppRechargeCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        money_textField.delegate = self
        money_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        next_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var select_button: UIButton!
    
    @IBOutlet weak var app_imageView: UIImageView!
    
    @IBOutlet weak var appName_label: UILabel!
    
    @IBOutlet weak var money_textField: UITextField!
    
    @IBOutlet weak var rate_label: UILabel!
    
    @IBOutlet weak var next_button: UIButton!
    
    var model: WPUserRateModel! = nil {
        didSet {
            rate_label.text = "0.00" + " x " + String(format: "%.2f%%", model.rate * 100) + " = " + "0.00"
        }
    }
    
    var appName: String! = nil {
        didSet {
            appName_label.text = appName
            app_imageView.image = WPInforTypeTool.appImage(appName: appName)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text, range: range, replacementString: string)
    }
    
    @objc func textFieldAction(_ textField: UITextField) {
        let money = (textField.text == nil || textField.text == "") ? "0" : textField.text!
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [textField.text!])
        rate_label.text = String(format: "%.2f", Float(money)!) + " x " + String(format: "%.2f%%", model.rate * 100) + " = " + String(format: "%.2f", model.rate * Float(money)!)
    }
    
}
