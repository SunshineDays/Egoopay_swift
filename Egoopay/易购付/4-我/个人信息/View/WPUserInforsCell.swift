//
//  WPUserInforsCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/18.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserInforsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        self.avater_imageView.layer.cornerRadius = WPCornerRadius;
        self.avater_imageView.layer.masksToBounds = true;
        self.avater_imageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var avater_imageView: UIImageView!
    
    @IBOutlet weak var center_label: UILabel!
    
}
