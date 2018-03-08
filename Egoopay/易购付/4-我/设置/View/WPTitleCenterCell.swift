//
//  WPTitleCenterCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPTitleCenterCellID = "WPTitleCenterCellID"

class WPTitleCenterCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
}
