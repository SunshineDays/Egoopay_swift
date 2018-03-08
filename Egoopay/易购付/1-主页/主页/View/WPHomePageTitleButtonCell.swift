//
//  WPHomePageTitleButtonCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/3/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPHomePageTitleButtonCellID = "WPHomePageTitleButtonCellID"

class WPHomePageTitleButtonCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var titleA_label: UILabel!
    
    @IBOutlet weak var titleB_label: UILabel!
    
    
}
