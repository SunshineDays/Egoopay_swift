//
//  WPUserApprovePhotoCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPUserApprovePhotoCellID = "WPUserApprovePhotoCellID"

class WPUserApprovePhotoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        front_button.layer.cornerRadius = WPCornerRadius
        front_button.layer.borderWidth = 1
        front_button.layer.borderColor = UIColor.lineColor().cgColor
        front_button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        contrary_button.layer.cornerRadius = WPCornerRadius
        contrary_button.layer.borderWidth = 1
        contrary_button.layer.borderColor = UIColor.lineColor().cgColor
        contrary_button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        hand_button.layer.cornerRadius = WPCornerRadius
        hand_button.layer.borderWidth = 1
        hand_button.layer.borderColor = UIColor.lineColor().cgColor
        hand_button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                
        confirm_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var front_button: UIButton!
    
    @IBOutlet weak var contrary_button: UIButton!
    
    @IBOutlet weak var hand_button: UIButton!
    
    @IBOutlet weak var standard_button: UIButton!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    
    
}
