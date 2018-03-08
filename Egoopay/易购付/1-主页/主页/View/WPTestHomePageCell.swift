//
//  WPTestHomePageCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/18.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPTestHomePageCellID = "WPTestHomePageCellID"

class WPTestHomePageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var gathering_button: UIButton!
    
    @IBOutlet weak var bill_button: UIButton!
    
    @IBOutlet weak var shop_button: UIButton!
    
    @IBOutlet weak var phone_button: UIButton!
    
    @IBOutlet weak var withDraw_button: UIButton!
    
    @IBOutlet weak var transfer_button: UIButton!
    
    @IBOutlet weak var code_button: UIButton!
    
    @IBOutlet weak var shopEnter_button: UIButton!
    
    @IBOutlet weak var myMember_button: UIButton!
    
    @IBOutlet weak var partner_button: UIButton!
}
