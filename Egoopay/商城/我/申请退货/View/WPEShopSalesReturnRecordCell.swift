//
//  WPEShopSalesReturnRecordCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/15.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopSalesReturnRecordCellID = "WPEShopSalesReturnRecordCellID"

class WPEShopSalesReturnRecordCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tel_button.setTitle(WPAppTelNumber, for: .normal)
        tel_button.addTarget(self, action: #selector(self.telAction), for: .touchUpInside)
        tel_button.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var state_label: UILabel!
    
    @IBOutlet weak var totalMoney_label: UILabel!
    
    @IBOutlet weak var account_label: UILabel!
    
    @IBOutlet weak var state_imageView: UIImageView!
    
    @IBOutlet weak var shop_imageView: UIImageView!
    
    @IBOutlet weak var shopName_label: UILabel!
    
    @IBOutlet weak var shopPrice_label: UILabel!
    
    @IBOutlet weak var shopNumber_label: UILabel!
    
    @IBOutlet weak var reason_label: UILabel!
    
    @IBOutlet weak var returnMoney_label: UILabel!
    
    @IBOutlet weak var date_label: UILabel!
    
    @IBOutlet weak var returnOrderNumber_label: UILabel!
    
    @IBOutlet weak var tel_button: UIButton!
    
    
    @objc func telAction() {
        WPInterfaceTool.callToNum(numString: WPAppTelNumber)
    }
    
}
