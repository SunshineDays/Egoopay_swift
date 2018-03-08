//
//  WPHomePagesCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/3/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPHomePagesCellID = "WPHomePagesCellID"

class WPHomePagesCell: UITableViewCell {

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
    
    @IBOutlet weak var titleC_label: UILabel!
    
    @IBOutlet weak var background_imageView: UIImageView!
    
}
