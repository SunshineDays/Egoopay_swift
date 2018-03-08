//
//  WPNewFeatureCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/12.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPNewFeatureCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonSpace.constant = UIApplication.shared.statusBarFrame.size.height == 44 ? 34 + 20 : 20
    }

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var register_button: UIButton!

    @IBOutlet weak var buttonSpace: NSLayoutConstraint!
    
}
