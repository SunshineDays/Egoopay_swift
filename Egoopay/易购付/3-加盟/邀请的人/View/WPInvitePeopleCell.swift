//
//  WPInvitePeopleCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPInvitePeopleCellID = "WPInvitePeopleCellID"

class WPInvitePeopleCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var phone_label: UILabel!
    
    @IBOutlet weak var shopNumber_label: UILabel!
    
    @IBOutlet weak var approveState_label: UILabel!
 
    
    var model: WPInvitingPeopleModel! = nil {
        didSet {
            phone_label.text = "手机号码：" + WPPublicTool.stringStar(string: model.phone, headerIndex: 3, footerIndex: 4)
            shopNumber_label.text = "商户编号：" + model.merNo
            approveState_label.text = model.name.count > 0 ? String(format: " (%@)", WPPublicTool.stringStar(string: model.name, headerIndex: 1, footerIndex: 0)) : " (未实名)"
        }
    }
    
}
