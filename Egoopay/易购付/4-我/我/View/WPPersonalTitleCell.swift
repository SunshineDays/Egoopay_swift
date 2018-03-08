//
//  WPPersonalTitleCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/24.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPersonalTitleCellID = "WPPersonalTitleCellID"

class WPPersonalTitleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.themeColor()
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        self.selectionStyle = UITableViewCellSelectionStyle.none

        title_imageView.layer.cornerRadius = WPCornerRadius
        title_imageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var titleA_label: UILabel!
    
    @IBOutlet weak var titleB_label: UILabel!
    
    
    var model: WPUserInforModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            
            titleA_label.text = model.nickname
            
            titleB_label.text = WPPublicTool.stringStar(string: model.phone, headerIndex: 3, footerIndex: 4)
        }
    }
}
