//
//  WPNewVersionCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/17.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPNewVersionCellID = "WPNewVersionCellID"

class WPNewVersionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        version_imageView.image = WPJudgeTool.isText() ? nil : #imageLiteral(resourceName: "icon_newVersion")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var version_imageView: UIImageView!
    
}
