//
//  WPEShopLogisticsCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/2.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopLogisticsCellID = "WPEShopLogisticsCellID"

class WPEShopLogisticsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    
    @IBOutlet weak var sign_imageView: UIImageView!
    
    @IBOutlet weak var lineUp_view: UIView!
    
    @IBOutlet weak var lineDown_view: UIView!
    
    
    
    
}
