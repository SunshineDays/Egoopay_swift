//
//  WPEShopPayOrderWithAppHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopPayOrderWithAppHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(imageView)
        self.addSubview(price_label)
        self.addSubview(orderId_label)
        
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: orderId_label.frame.maxY + 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initInfor(price: Double, orderId: String) {
        price_label.text = String(format: "￥%.2f", price)
        orderId_label.text = "订单编号 - " + orderId
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 225 / 1080))
        imageView.image = #imageLiteral(resourceName: "icon_eShop_payWithTitle")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var price_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: self.imageView.frame.maxY + 20, width: kScreenWidth, height: 30))
        label.text = "￥0.00"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    lazy var orderId_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: self.price_label.frame.maxY + 5, width: kScreenWidth, height: 20))
        label.text = "订单编号"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
}
