//
//  WPProductTitleCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPProductTitleCellID = "WPProductTitleCellID"

class WPProductTitleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.backgroundColor()
        
        avater_imageView.layer.cornerRadius = WPCornerRadius
        avater_imageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var avater_imageView: UIImageView!
    
    @IBOutlet weak var phone_label: UILabel!
    
    @IBOutlet weak var lv_label: UILabel!
    
    @IBOutlet weak var lv_imageView: UIImageView!
    
    @IBOutlet weak var commission_label: UILabel!
    
    @IBOutlet weak var benefit_label: UILabel!
    
    var inforModel: WPUserInforModel! = nil {
        didSet {
            avater_imageView.sd_setImage(with: URL.init(string: inforModel.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            phone_label.text = inforModel.phone
            lv_label.text = WPInforTypeTool.userVip(agentGradeID: inforModel.agentGradeId)
        }
    }
    
    var poundageModel: WPPoundageModel! = nil {
        didSet {
            commission_label.text = "佣金比例 " + String(format: "%.2f", poundageModel.commissionRate * 100) + "%"
            benefit_label.text = "分润比例 " + String(format: "%.2f", poundageModel.benefitRate * 100) + "%"
        }
    }
    
    
    
}
