//
//  WPAMapLocationCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPAMapLocationCellID = "WPAMapLocationCellID"

class WPAMapLocationCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        taxi_label.textColor = UIColor.themeColor()
        
        go_button.layer.cornerRadius = WPCornerRadius
        go_button.backgroundColor = UIColor.themeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var address_label: UILabel!
    
    @IBOutlet weak var distance_label: UILabel!
    
    @IBOutlet weak var taxi_button: UIButton!
    @IBOutlet weak var taxi_label: UILabel!
    
    @IBOutlet weak var bus_button: UIButton!
    @IBOutlet weak var bus_label: UILabel!
    
    @IBOutlet weak var walk_button: UIButton!
    @IBOutlet weak var walk_label: UILabel!
    
    @IBOutlet weak var go_button: UIButton!
    
    
    
        
}
