//
//  WPAgencyCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/2.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPAgencyCellID = "WPAgencyCellID"

class WPAgencyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var titleA_label: UILabel!
    
    @IBOutlet weak var titleB_label: UILabel!
}
