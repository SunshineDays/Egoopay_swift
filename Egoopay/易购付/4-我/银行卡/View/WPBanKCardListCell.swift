//
//  WPBanKCardListCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/15.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBanKCardListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.panel_view.layer.cornerRadius = WPCornerRadius
        self.card_imageView.contentMode = UIViewContentMode.scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var panel_view: UIView!
    
    @IBOutlet weak var card_imageView: UIImageView!
    
    @IBOutlet weak var cardName_label: UILabel!
    
    @IBOutlet weak var cardType_label: UILabel!
    
    @IBOutlet weak var cardNumber_label: UILabel!
    
    @IBOutlet weak var cardState_label: UILabel!
    
    var model: WPBankCardModel! = nil {
        didSet {
            card_imageView.image = WPInforTypeTool.bankImage(model: model)
            
            cardName_label.text = model.bankName
            
            cardType_label.text = model.cardType == 1 ? "信用卡" : "储蓄卡"
            self.panel_view.backgroundColor = model.cardType == 1 ? UIColor.colorConvert(colorString: "#E7576E") : UIColor.colorConvert(colorString: "#1BB093")
            
//            cardNumber_label.text = WPPublicTool.stringStar(string: WPPublicTool.base64DecodeString(string: model.cardNumber), headerIndex: 0, footerIndex: 4)
            
            cardNumber_label.text = "**** **** **** " + model.lastNumber
            
            switch (model.extCardType) {
            case 3:
                self.cardState_label.text = "JCB"
            case 4:
                self.cardState_label.text = "VISA"
            case 5:
                self.cardState_label.text = "MASTER"
            default:
                break;
            }
            
        }
    }
    
    
    
    
}
