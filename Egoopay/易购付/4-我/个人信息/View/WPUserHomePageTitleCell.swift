//
//  WPUserHomePageTitleCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPUserHomePageTitleCellID = "WPUserHomePageTitleCellID"

class WPUserHomePageTitleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.theme_view.backgroundColor = UIColor.themeColor()
        
        self.avater_button.layer.cornerRadius = WPCornerRadius
        self.avater_button.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var theme_view: UIView!
    
    @IBOutlet weak var avater_button: UIButton!
    
    
    @IBOutlet weak var nickname_button: UIButton!
    
    
    var model: WPUserInforModel! = nil {
        didSet {
            avater_button.sd_setBackgroundImage(with: URL.init(string: self.model.picurl), for: UIControlState.normal, placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            nickname_button.setTitle(model.nickname, for: .normal)
        }
    }
    
}
