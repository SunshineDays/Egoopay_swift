//
//  WPBalanceCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBalanceCellID = "WPBalanceCellID"

class WPBalanceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.themeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var balance_label: UILabel!
    
    
}
