//
//  WPBankCardDetailHeaderCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/10.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBankCardDetailHeaderCellID = "WPBankCardDetailHeaderCellID"

class WPBankCardDetailHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.colorConvert(colorString: "36353A")
        
        self.layer.masksToBounds = true
        
        panel_view.layer.shadowOffset = CGSize(width: 0, height: 0)
        panel_view.layer.shadowOpacity = 0.8
        panel_view.layer.shadowColor = UIColor.gray.cgColor
        panel_view.layer.masksToBounds = true
        panel_view.layer.cornerRadius = WPCornerRadius
        
        bank_imageView.layer.masksToBounds = true
        bank_imageView.layer.cornerRadius = 20
        
        set_button.layer.borderColor = UIColor.white.cgColor
        set_button.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var panel_view: UIView!
    
    @IBOutlet weak var bank_imageView: UIImageView!
    
    @IBOutlet weak var bankName_label: UILabel!
    
    @IBOutlet weak var cardType_label: UILabel!
    
    @IBOutlet weak var cardNum_label: UILabel!
    
    @IBOutlet weak var cardState_label: UILabel!
    
    @IBOutlet weak var set_button: UIButton!
    
    var model: WPBankCardModel! = nil {
        didSet {
            bank_imageView.image = WPInforTypeTool.bankImage(model: model)
            
            bankName_label.text = model.bankName
            
            cardType_label.text = model.cardType == 1 ? "信用卡" : "储蓄卡"
            panel_view.backgroundColor = model.cardType == 1 ? UIColor.colorConvert(colorString: "#E7576E") : UIColor.colorConvert(colorString: "#1BB093")
            
            cardNum_label.text = "**** **** **** " + model.lastNumber
            
            switch (model.extCardType) {
            case 3:
                self.cardState_label.text = "JCB"
            case 4:
                self.cardState_label.text = "VISA"
            case 5:
                self.cardState_label.text = "MASTER"
            default:
                self.cardState_label.text = ""
            }

            
            //是 储蓄卡
            if model.cardType == 2 {
                if model.isReceive == 1 { //是收款银行卡
                    set_button.setTitle("  默认二维码收款银行卡  ", for: .normal)
                    set_button.isUserInteractionEnabled = false
                }
                else {
                    set_button.setTitle("  设置为收款银行卡  ", for: .normal)
                }
            }
            else {
                set_button.isHidden = true
            }
        }
    }
}
