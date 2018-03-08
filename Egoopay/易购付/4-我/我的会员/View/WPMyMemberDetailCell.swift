//
//  WPMyMemberDetailCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/12.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPMyMemberDetailCellID = "WPMyMemberDetailCellID"

class WPMyMemberDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        theme_view.backgroundColor = UIColor.themeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var theme_view: UIView!
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var vipName_label: UILabel!
    
    @IBOutlet weak var vipPrice_label: UILabel!
    
    
    var model: WPMemberModel! = nil {
        didSet {
            title_imageView.image = WPInforTypeTool.userVipImage(merchantlvID: model.levelNo)
            vipName_label.text = model.lvname
            vipPrice_label.text = String(format: "￥%.2f", model.price)
        }
    }
    
}
