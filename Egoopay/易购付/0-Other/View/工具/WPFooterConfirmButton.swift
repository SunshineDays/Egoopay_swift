//
//  WPFooterConfirmButton.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/12.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPFooterConfirmButton: UIView {

    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 85))
        self.addSubview(confirm_button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var confirm_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 15, y: 25, width: kScreenWidth - 30, height: 45))
        button.setTitle("下一步", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeColor()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = WPCornerRadius
        return button
    }()
    
}
