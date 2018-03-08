//
//  WPFeedbackCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPFeedbackCellID = "WPFeedbackCellID"

class WPFeedbackCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var number_label: UILabel!
    
}
