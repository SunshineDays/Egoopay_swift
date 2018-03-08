//
//  WPBenefitWithDrawRecordCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/26.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPBenefitWithDrawRecordCellID = "WPBenefitWithDrawRecordCellID"

class WPBenefitWithDrawRecordCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    
    var model: WPBenefitWithDrawRecordModel! = nil {
        didSet {
            title_label.text = model.remark
            money_label.text = String(format: "%.2f", model.amount)
            time_label.text = WPPublicTool.stringCustom(date: model.createDate)
        }
    }
    
    
}
