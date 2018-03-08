//
//  WPBenfitsDetailCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPBenfitsDetailCellID = "WPBenfitsDetailCellID"

class WPBenfitsDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var shopNumber_label: UILabel!
    
    @IBOutlet weak var shopMoney_label: UILabel!
    
    @IBOutlet weak var benefit_label: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    
    
    var model: WPBenefitDetailModel! = nil {
        didSet {
            
            shopNumber_label.text = "商户编号：" + model.merchantno
            
            time_label.text = WPPublicTool.stringToDate(date: model.createTime)

            if model.benefit > 0 {
                shopMoney_label.text = String(format: "交易金额：%.2f", model.txAmount)
                benefit_label.text = String(format: "+%.2f", model.benefit)
            }
            else if model.commission > 0 {
                shopMoney_label.text = "交易类型：升级为加盟商"
                benefit_label.text = String(format: "+%.2f", model.commission)
            }
            
            
            
            
        }
    }
    
}
