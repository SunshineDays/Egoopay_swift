//
//  WPSelectCardCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/24.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPSelectCardCellID = "WPSelectCardCellID"

class WPSelectCardCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var bank_imageView: UIImageView!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var number_label: UILabel!
    
    @IBOutlet weak var select_label: UILabel!
    
    var cardID = NSInteger()
    
    var model: WPBankCardModel! = nil {
        didSet {
            bank_imageView.image = WPInforTypeTool.bankImage(model: model)
            if model.bankName.count > 0 {
                name_label.text = model.bankName
//                let number = WPPublicTool.base64DecodeString(string: model.cardNumber)
                number_label.text = "尾号 " + model.lastNumber
                select_label.isHidden = true
            }
            else {
                select_label.isHidden = false
                name_label.isHidden = true
                number_label.isHidden = true
            }
        }
    }
    
}
