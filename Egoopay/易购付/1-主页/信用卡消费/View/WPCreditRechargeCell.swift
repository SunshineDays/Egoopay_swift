//
//  WPCreditRechargeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/7.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPCreditRechargeCellID = "WPCreditRechargeCellID"

class WPCreditRechargeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        panpel_view.backgroundColor = UIColor.tableViewColor()
        next_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var selectA_button: UIButton!
    
    @IBOutlet weak var cardA_imageView: UIImageView!
    
    @IBOutlet weak var titleA_label: UILabel!
    
    @IBOutlet weak var typeA_label: UILabel!
    
    @IBOutlet weak var selectA_label: UILabel!
    
    @IBOutlet weak var selectB_button: UIButton!
    
    @IBOutlet weak var cardB_imageView: UIImageView!
    
    @IBOutlet weak var titleB_label: UILabel!
    
    @IBOutlet weak var typeB_label: UILabel!
    
    @IBOutlet weak var selectB_label: UILabel!
    
    @IBOutlet weak var panpel_view: UIView!
    
    @IBOutlet weak var next_button: UIButton!
    
    
    /**  选择信用卡模型 */
    var credit_model: WPBankCardModel! = nil {
        didSet {
            cardA_imageView.image = WPInforTypeTool.bankImage(model: credit_model)
            if credit_model.bankName.count > 0 {
                titleA_label.text = credit_model.bankName
                typeA_label.text = "尾号 " + credit_model.lastNumber
                selectA_label.isHidden = true
                titleA_label.isHidden = false
                typeA_label.isHidden = false
            }
            else {
                selectA_label.isHidden = false
                titleA_label.isHidden = true
                typeA_label.isHidden = true
            }
        }
    }
    
    /**  选择储蓄卡模型 */
    var deposit_model: WPBankCardModel! = nil {
        didSet {
            cardB_imageView.image = WPInforTypeTool.bankImage(model: deposit_model)
            if deposit_model.bankName.count > 0 {
                titleB_label.text = deposit_model.bankName
                typeB_label.text = "尾号 " + deposit_model.lastNumber
                selectB_label.isHidden = true
                titleB_label.isHidden = false
                typeB_label.isHidden = false
            }
            else {
                selectB_label.isHidden = false
                titleB_label.isHidden = true
                typeB_label.isHidden = true
            }
        }
    }
    
    
    
}
