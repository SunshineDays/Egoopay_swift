//
//  WPInputInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/19.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPInputInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.title_textField.clearButtonMode = UITextFieldViewMode.always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_textField: UITextField!
    
}
