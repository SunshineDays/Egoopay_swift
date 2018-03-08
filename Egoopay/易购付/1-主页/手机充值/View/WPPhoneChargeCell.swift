//
//  WPPhoneChargeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPhoneChargeCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.themeColor().cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = WPCornerRadius
        self.layer.masksToBounds = true
    }

    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    
}
