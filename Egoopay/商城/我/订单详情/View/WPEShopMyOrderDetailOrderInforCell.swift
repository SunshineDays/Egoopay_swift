//
//  WPEShopMyOrderDetailOrderInforCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyOrderDetailOrderInforCellID = "WPEShopMyOrderDetailOrderInforCellID"

class WPEShopMyOrderDetailOrderInforCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        copy_button.layer.cornerRadius = 3
        copy_button.layer.borderColor = UIColor.lineColor().cgColor
        copy_button.layer.borderWidth = WPLineHeight
        copy_button.addTarget(self, action: #selector(self.copyAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var orderNumber_label: UILabel!
    
    @IBOutlet weak var copy_button: UIButton!
    
    @IBOutlet weak var orderTime_label: UILabel!
    
    @IBOutlet weak var payWay_label: UILabel!
    
    @IBOutlet weak var transWay_label: UILabel!
    
    @IBOutlet weak var note_label: UILabel!
    
    @IBOutlet weak var commodityMoney_label: UILabel!
    
    @IBOutlet weak var freight_label: UILabel!
    
    @IBOutlet weak var discounts_label: UILabel!
    
    @IBOutlet weak var totalMoney_label: UILabel!
    
    @IBOutlet weak var status_label: UILabel!
    
    var model: WPEShopMyOrderDetailModel! = nil {
        didSet {
            orderNumber_label.text = model.order_info_id
            orderTime_label.text = model.date_added
            commodityMoney_label.text = String(format: "￥%.2f", model.total)
            freight_label.text = "+￥0.00"
            discounts_label.text = "-￥0.00"
            totalMoney_label.text = String(format: "￥%.2f", model.total)
            transWay_label.text = model.shipping_method
            payWay_label.text = model.payment_method.count > 0 ? model.payment_method : "在线支付"
            note_label.text = model.comment.count > 0 ? model.comment : "无"
            
            status_label.text = model.order_status == "待付款" ? "需付款" : "实付款"
        }
    }
    
    
    @objc func copyAction() {
        let pastedboard = UIPasteboard.general
        pastedboard.string = orderNumber_label.text
        WPProgressHUD.showInfor(status: "已复制到剪切板")
    }
}
