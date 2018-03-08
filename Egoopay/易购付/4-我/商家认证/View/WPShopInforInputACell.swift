//
//  WPShopInforInputACell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPShopInforInputACellID = "WPShopInforInputACellID"

class WPShopInforInputACell: UITableViewCell, UITextViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        next_button.layer.cornerRadius = WPCornerRadius
        
        linkName_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        tel_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        shopName_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        shopAddressDetail_textField.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .editingChanged)
        
        sex_button.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .touchUpInside)
        shopAddress_button.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .touchUpInside)
        shopCategory_button.addTarget(self, action: #selector(self.changeNextButtonColorAction), for: .touchUpInside)

        shopDescp_textView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var linkName_textField: UITextField!
    
    @IBOutlet weak var sex_button: UIButton!
    
    @IBOutlet weak var tel_textField: UITextField!
    
    @IBOutlet weak var shopName_textField: UITextField!
    
    @IBOutlet weak var shopAddress_button: UIButton!
    
    @IBOutlet weak var shopAddressDetail_textField: UITextField!
    
    @IBOutlet weak var shopCategory_button: UIButton!
    
    @IBOutlet weak var shopDescp_textView: UITextView!
    
    @IBOutlet weak var next_button: UIButton!
    
    
    @objc func changeNextButtonColorAction() {
        WPInterfaceTool.adjustButtonColor(button: next_button, array: [linkName_textField.text!, sex_button.currentTitle ?? "", tel_textField.text!, shopName_textField.text!, shopAddress_button.currentTitle ?? "", shopAddressDetail_textField.text!, shopCategory_button.currentTitle ?? "", shopDescp_textView.text!])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeNextButtonColorAction()
    }
    
    
}
