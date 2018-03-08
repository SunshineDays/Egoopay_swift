//
//  WPMyMemberHeaderCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/10.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPMyMemberHeaderCellID = "WPMyMemberHeaderCellID"

class WPMyMemberHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avater_imageView.layer.masksToBounds = true
        avater_imageView.layer.borderWidth = 1
        avater_imageView.layer.borderColor = UIColor.white.cgColor
        avater_imageView.layer.cornerRadius = 3
        
        vip_imageView.layer.masksToBounds = true
        vip_imageView.layer.borderWidth = 1
        vip_imageView.layer.borderColor = UIColor.white.cgColor
        vip_imageView.layer.cornerRadius = 12.5
        
        self.backgroundColor = UIColor.themeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var avater_imageView: UIImageView!
    
    @IBOutlet weak var vip_imageView: UIImageView!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var title_label: UILabel!
    
    var model: WPUserInforModel! = nil {
        didSet {
            avater_imageView.sd_setImage(with: URL.init(string: model.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            
            vip_imageView.image = WPInforTypeTool.userVipImage(merchantlvID: model.merchantlvid)
            
            title_label.text = model.phone
            
            content_label.text = WPInforTypeTool.userVip(merchantlvID: model.merchantlvid)
        }
    }
}
