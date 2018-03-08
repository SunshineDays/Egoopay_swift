//
//  WPInputTextFieldCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/19.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPInputTextFieldCellID = "WPInputTextFieldCellID"

class WPInputTextFieldCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_textField: UITextField!
    
}
