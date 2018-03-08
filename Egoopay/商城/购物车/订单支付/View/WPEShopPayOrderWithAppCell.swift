//
//  WPEShopPayOrderWithAppCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopPayOrderWithAppCellID = "WPEShopPayOrderWithAppCellID"

class WPEShopPayOrderWithAppCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var app_imageView: UIImageView!
    
    @IBOutlet weak var appName_label: UILabel!
    
    @IBOutlet weak var select_iamgeView: UIImageView!
    
}
