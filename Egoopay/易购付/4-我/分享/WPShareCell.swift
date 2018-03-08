//
//  WPShareCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPShareCellID = "WPShareCellID"

class WPShareCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }

    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var share_button: UIButton!
}
