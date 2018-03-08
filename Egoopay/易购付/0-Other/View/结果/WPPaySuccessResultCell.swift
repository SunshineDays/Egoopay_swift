//
//  WPPaySuccessResultCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPaySuccessResultCellID = "WPPaySuccessResultCellID"

class WPPaySuccessResultCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var finish_button: UIButton!
    
    @IBOutlet weak var typeResult_label: UILabel!
    
    @IBOutlet weak var Money_label: UILabel!
    
    @IBOutlet weak var payState_label: UILabel!
    
}
