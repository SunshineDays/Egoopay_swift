//
//  WPCreditSelectChannelCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/12.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPCreditSelectChannelCellID = "WPCreditSelectChannelCellID"

class WPCreditSelectChannelCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        theme_view.backgroundColor = UIColor.tableViewColor()
        rate_label.textColor = UIColor.themeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var channelName_label: UILabel!
    
    @IBOutlet weak var limit_label: UILabel!
    
    @IBOutlet weak var finish_label: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    
    @IBOutlet weak var rate_label: UILabel!
    
    @IBOutlet weak var hint_label: UILabel!
    
    @IBOutlet weak var theme_view: UIView!
    
    var model: WPCreditChannelModel! = nil {
        didSet {
            channelName_label.text = model.fullName
            
            limit_label.text = "额度：" + String(format: "%.0f ~ %.0f元/笔", model.minAmount, model.maxAmount)
            
            finish_label.text = "结算：" + model.settleMode
            
            time_label.text = "时间：" + model.startDate + " ~ " + model.endDate
            
            hint_label.text = "提示：" + model.message
            
            rate_label.text = "费率：" + String(format: "%.2f%%", model.rate * 100) + "+" + String(format: "%.2f", model.fee) + "元/笔"

        }
    }
    
}
