//
//  WPTitleTitleCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/1.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPTitleTitleCellID = "WPTitleTitleCellID"

class WPTitleTitleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var titleA_label: UILabel!
    
    @IBOutlet weak var titleB_label: UILabel!
    
    var model: WPMessageSystemModel! = nil {
        didSet {
            self.titleA_label.text = model.title
            self.titleB_label.text = WPPublicTool.stringToDate(date: model.create_time)
        }
    }
    
}
