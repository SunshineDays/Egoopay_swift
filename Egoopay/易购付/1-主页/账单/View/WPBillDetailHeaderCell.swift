//
//  WPBillDetailHeaderCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/26.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPBillDetailHeaderCellID = "WPBillDetailHeaderCellID"

class WPBillDetailHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var type_imageView: UIImageView!
    
    @IBOutlet weak var type_label: UILabel!
    
    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var state_label: UILabel!
    
    var model: WPBillInforListModel! = nil {
        didSet {
            type_imageView.image = WPInforTypeTool.billImage(model: model)
            type_label.text = model.payStateName
            money_label.text = String(format: "%.2f", model.amount)
            state_label.text = model.tradeTypeName
        }
    }
    
}
