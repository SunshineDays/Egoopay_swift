//
//  WPShoppingCartView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShoppingCartView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(line_view)
        self.addSubview(select_button)
        self.addSubview(total_label)
        self.addSubview(money_label)
        self.addSubview(pay_button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
    lazy var select_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 10, y: 12.5, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        return button
    }()
    
    lazy var total_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: self.select_button.frame.maxX + 5, y: 0, width: 30, height: 55))
        label.text = "全选"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var money_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: self.total_label.frame.maxX + 5, y: 0, width: 200, height: 55))
        label.text = "合计:￥0.00"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var pay_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 120, y: 0, width: 120, height: 55))
        button.backgroundColor = UIColor.priceTextColor()
        button.setTitle("去结算(0)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
}
