//
//  WPEShopSearchHotCollectionCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopSearchHotCollectionCellID = "WPEShopSearchHotCollectionCellID"

class WPEShopSearchHotCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.themeEShopColor().cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = WPCornerRadius
        title_label.textColor = UIColor.themeEShopColor()
    }

    @IBOutlet weak var title_label: UILabel!
}
