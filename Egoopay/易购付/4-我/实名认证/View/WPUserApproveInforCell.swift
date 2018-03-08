//
//  WPUserApproveInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPUserApproveInforCellID = "WPUserApproveInforCellID"

class WPUserApproveInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avater_imageView.layer.cornerRadius = WPCornerRadius
        avater_imageView.layer.masksToBounds = true
        
        panpel_view.layer.cornerRadius = WPCornerRadius
        panpel_view.layer.borderColor = UIColor.lineColor().cgColor
        panpel_view.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var avater_imageView: UIImageView!
    
    @IBOutlet weak var panpel_view: UIView!
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var number_label: UILabel!
    
    var avater_url = String()
    
    var model: WPUserApproveModel! = nil {
        didSet {
            
            avater_imageView.sd_setImage(with: URL.init(string: avater_url), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            
            name_label.text = model.fullName
            
            number_label.text = model.infomation
            
//            number_label.text = WPPublicTool.stringStar(string: WPPublicTool.base64DecodeString(string: model.identityCard), headerIndex: 1, footerIndex: 1)
        }
    }
    
    
    
}
