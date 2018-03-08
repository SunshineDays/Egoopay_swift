//
//  WPCustomView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPCustomView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class WPThemeColorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: -kScreenHeight * 2, width: kScreenWidth, height: kScreenHeight * 2)
        self.backgroundColor = UIColor.themeColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
