//
//  WPImageTitleContentCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/20.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPImageTitleContentCellID = "WPImageTitleContentCellID"

class WPImageTitleContentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imgeView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
}
