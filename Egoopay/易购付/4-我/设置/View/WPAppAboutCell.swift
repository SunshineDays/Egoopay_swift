//
//  WPAppAboutCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPAppAboutCellID = "WPAppAboutCellID"

class WPAppAboutCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.clear
        
        app_imageView.layer.cornerRadius = 12
        app_imageView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var app_imageView: UIImageView!
    
    @IBOutlet weak var appVersion_label: UILabel!
    
}
