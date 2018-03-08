//
//  WPTouchIDCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPTouchIDCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var select_switch: UISwitch!
    
    
    
}
