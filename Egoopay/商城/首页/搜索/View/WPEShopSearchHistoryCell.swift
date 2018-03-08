//
//  WPEShopSearchHistoryCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopSearchHistoryCellID = "WPEShopSearchHistoryCellID"

class WPEShopSearchHistoryCell: UITableViewCell {

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
