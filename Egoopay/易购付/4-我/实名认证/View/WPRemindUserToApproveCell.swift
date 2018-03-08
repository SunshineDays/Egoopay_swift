//
//  WPRemindUserToApproveCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/5.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPRemindUserToApproveCellID = "WPRemindUserToApproveCellID"

class WPRemindUserToApproveCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 6
        
        self.confirm_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var confirm_button: UIButton!
    
    @IBOutlet weak var cancel_button: UIButton!
}
