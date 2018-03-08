//
//  WPConfirmButtonCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/19.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPConfirmButtonCellID = "WPConfirmButtonCellID"

class WPConfirmButtonCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirm_button.layer.cornerRadius = WPCornerRadius
//        confirm_button.layer.shadowOffset = CGSize(width: 0, height: 0)
//        confirm_button.layer.shadowOpacity = 0.8
//        confirm_button.layer.shadowColor = UIColor.gray.cgColor
        confirm_button.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var confirm_button: UIButton!
}
