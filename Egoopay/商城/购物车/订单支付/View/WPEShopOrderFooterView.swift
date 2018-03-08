//
//  WPEShopOrderFooterView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopOrderFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(pay_button)
        self.addSubview(money_label)
        self.addSubview(line_view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var pay_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth / 3 * 2, y: 0, width: kScreenWidth / 3, height: self.frame.size.height))
        button.setTitle("提交订单", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.red
        return button
    }()
    
    lazy var money_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: kScreenWidth / 2, height: self.frame.size.height))
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
}
