//
//  WPPayInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/20.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPayInforCellID = "WPPayInforCellID"

class WPPayInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirm_button.layer.cornerRadius = WPCornerRadius
        confirm_button.backgroundColor = UIColor.themeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var cancel_button: UIButton!
    
    @IBOutlet weak var price_label: UILabel!
    
    @IBOutlet weak var orderInfor_label: UILabel!
    
    @IBOutlet weak var payWay_label: UILabel!
    
    @IBOutlet weak var payWay_button: UIButton!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    var wayName = String()
    
    var model: WPOrderModel! = nil {
        didSet {
            price_label.text = "￥" + String(format: "%.2f", model.amount)
            orderInfor_label.text = model.remark
        }
    }
    
}
