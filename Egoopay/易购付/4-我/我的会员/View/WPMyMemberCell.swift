//
//  WPMyMemberCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/10.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPMyMemberCellID = "WPMyMemberCellID"

class WPMyMemberCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    var model: WPMemberModel! = nil {
        didSet {
            title_imageView.image = WPInforTypeTool.userVipImage(merchantlvID: model.levelNo)
            
            title_label.text = model.lvname
            
            content_label.text = model.descMsg
            
        }
    }
    
}
