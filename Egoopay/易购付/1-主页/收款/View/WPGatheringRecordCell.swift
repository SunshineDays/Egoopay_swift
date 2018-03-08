//
//  WPGatheringRecordCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/9.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPGatheringRecordCellID = "WPGatheringRecordCellID"

class WPGatheringRecordCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var way_label: UILabel!
    
    @IBOutlet weak var date_label: UILabel!
    
    @IBOutlet weak var money_label: UILabel!
    
    
    var model: WPBillInforModel! = nil {
        didSet {
            way_label.text = (WPInforTypeTool.billType(wayModel: model) == "" ? "支付宝" : WPInforTypeTool.billType(wayModel: model)) + "收款"
            
            date_label.text = WPPublicTool.stringCustom(date: model.createDate != "" ? model.createDate : model.finishDate)
            
            money_label.text = "+" + String(format: "%.2f", model.amount)
        }
    }
}
