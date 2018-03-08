//
//  WPTransferFriendCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPTransferFriendCellID = "WPTransferFriendCellID"

class WPTransferFriendCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.title_imageView.layer.cornerRadius = WPCornerRadius
        self.title_imageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var phone_label: UILabel!
    
    @IBOutlet weak var money_textField: UITextField!
    
}
