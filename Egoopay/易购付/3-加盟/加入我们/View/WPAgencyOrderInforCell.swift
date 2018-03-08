//
//  WPAgencyOrderInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPAgencyOrderInforCellID = "WPAgencyOrderInforCellID"

class WPAgencyOrderInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirm_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var currentVipName_label: UILabel!
    
    @IBOutlet weak var currentVipPrice_label: UILabel!
    
    @IBOutlet weak var currentDeposit_label: UILabel!
    
    @IBOutlet weak var vipName_label: UILabel!
    
    @IBOutlet weak var vipPrice_label: UILabel!
    
    @IBOutlet weak var vipDeposit_label: UILabel!
    
    @IBOutlet weak var total_label: UILabel!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    
    var curentDeposit: Float! = nil {
        didSet {
            currentDeposit_label.text = String(format: "￥%.2f", curentDeposit)
        }
    }
    
    var inforAgencyModel: WPAgencyProductAgUpListModel! = nil {
        didSet {
            currentVipName_label.text = inforAgencyModel.gradeName
            currentVipPrice_label.text = String(format: "￥%.2f", inforAgencyModel.price)
        }
    }
    
    var agencyModel: WPAgencyProductAgUpListModel! = nil {
        didSet {
            vipName_label.text = agencyModel.gradeName
            vipPrice_label.text = String(format: "￥%.2f", agencyModel.price - inforAgencyModel.price)
            vipDeposit_label.text = String(format: "￥%.2f", agencyModel.depositAmt - curentDeposit)
            total_label.text = String(format: "￥%.2f", (agencyModel.price - inforAgencyModel.price) + (agencyModel.depositAmt - curentDeposit))
        }
    }
    
}
