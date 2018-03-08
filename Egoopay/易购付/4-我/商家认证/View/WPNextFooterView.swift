//
//  WPNextFooterView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/28.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPNextFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 95)
        self.addSubview(next_button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String! = nil {
        didSet {
            next_button.setTitle(title, for: UIControlState.normal)
        }
    }
    
    lazy var next_button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 35, width: kScreenWidth - 30, height: 45)
        button.backgroundColor = UIColor.themeColor()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = WPCornerRadius
        return button
    }()
    
}
