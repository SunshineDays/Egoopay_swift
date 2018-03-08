//
//  WPBillListCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBillListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.title_imageView.contentMode = UIViewContentMode.scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var payWay_label: UILabel!
    
    @IBOutlet weak var date_label: UILabel!
    
    @IBOutlet weak var state_label: UILabel!
    
    @IBOutlet weak var money_label: UILabel!
    
    var model: WPBillInforListModel! = nil {
        didSet {
            title_imageView.image = WPInforTypeTool.billImage(model: model)
            
            payWay_label.text = model.payStateName
            
            money_label.text = WPInforTypeTool.billSymbol(model: model)
            
            state_label.text = model.tradeTypeName
            
            state_label.textColor = WPInforTypeTool.billColor(model: model)
            
            date_label.text = WPPublicTool.stringCustom(date: model.createDate)
        }
    }
}
