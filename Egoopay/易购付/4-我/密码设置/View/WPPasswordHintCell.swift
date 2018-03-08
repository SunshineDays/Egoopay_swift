//
//  WPPasswordHintCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPasswordHintCellID = "WPPasswordHintCellID"

class WPPasswordHintCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title_label.text = "您是否要修改 " + WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)! + "\n\n" + "当前使用的支付密码"
        no_button.layer.borderColor = UIColor.lineColor().cgColor
        no_button.layer.borderWidth = WPLineHeight
        no_button.layer.cornerRadius = WPCornerRadius
        
        yes_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var no_button: UIButton!
    
    @IBOutlet weak var yes_button: UIButton!
}
