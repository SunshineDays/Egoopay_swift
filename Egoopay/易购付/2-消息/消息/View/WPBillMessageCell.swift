//
//  WPBillMessageCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBillMessageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = WPCornerRadius
        self.layer.borderColor = UIColor.lineColor().cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var result_label: UILabel!
    
    @IBOutlet weak var date_label: UILabel!
    
    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var way_label: UILabel!
    
    @IBOutlet weak var type_label: UILabel!
    
    @IBOutlet weak var number_label: UILabel!
    
    var model: WPBillInforListModel! = nil {
        didSet {
            result_label.text = model.payStateName + "成功"
            
            date_label.text = (WPPublicTool.stringToDate(date: model.createDate) as NSString).substring(to: WPPublicTool.stringToDate(date: model.createDate).count - 6)
            
            money_label.text = String(format: "%.2f", model.amount)
            
            way_label.text = model.payMethodName
            
            type_label.text = model.payStateName
            
            number_label.text = model.orderno
        }
    }
    
}
