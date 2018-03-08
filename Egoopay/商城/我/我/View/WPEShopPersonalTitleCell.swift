//
//  WPPersonalTitleCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopPersonalTitleCellID = "WPEShopPersonalTitleCellID"

class WPEShopPersonalTitleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        avater_imageView.layer.cornerRadius = avater_imageView.frame.size.width / 2
        avater_imageView.layer.masksToBounds = true
        vip_button.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var avater_imageView: UIImageView!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var vip_button: UIButton!
    
    @IBOutlet weak var love_label: UILabel!
    
    @IBOutlet weak var attention_label: UILabel!
    
    @IBOutlet weak var foot_label: UILabel!
    
    @IBOutlet weak var integral_label: UILabel!
    
    @IBOutlet weak var love_button: UIButton!
    
    @IBOutlet weak var attention_button: UIButton!
    
    @IBOutlet weak var foot_button: UIButton!
    
    @IBOutlet weak var integral_button: UIButton!
    
    var model: WPEShopPersonalModel! = nil {
        didSet {
            avater_imageView.sd_setImage(with: URL.init(string: model.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            name_label.text = WPPublicTool.stringStar(string: model.phone, headerIndex: 3, footerIndex: 4)
            vip_button.setTitle(WPInforTypeTool.userVip(merchantlvID: model.merchantlvid), for: .normal)
            love_label.text = String(format: "%d", model.wishlist_count)
            attention_label.text = String(format: "%d", model.wishlist_count)
            foot_label.text = String(format: "%d", model.footprint)
            integral_label.text = String(format: "%d", model.wishlist_count)

        }
    }
    
}
