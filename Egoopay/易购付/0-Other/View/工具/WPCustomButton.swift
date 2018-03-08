//
//  WPCustomButton.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

/**  主题按钮 */
class WPThemeButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.backgroundColor = UIColor.colorConvert(colorString: "#DDDDDD")
//        self.setTitleColor(UIColor.colorConvert(colorString: "BDBDBD"), for: .normal)
//        self.titleLabel?.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        
        self.backgroundColor = UIColor.themeColor()
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        
        self.layer.cornerRadius = WPCornerRadius
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = UIColor.gray.cgColor
        
    }
}

class WPTitleImageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.titleLabel?.center.x = 20
//        self.titleLabel?.center.y = 20
        
        self.titleLabel?.frame.origin.x = 0
        self.titleLabel?.frame.origin.y = 0
        self.titleLabel?.frame.size.width = 40
        self.titleLabel?.frame.size.height = 40
        
        self.titleLabel?.textAlignment = .center
        
        self.imageView?.frame.origin.x = 40
        self.imageView?.frame.origin.y = 5
        self.imageView?.frame.size.width = 15
        self.imageView?.frame.size.height = 30
        
        self.imageView?.contentMode = .scaleAspectFit
        
    }
}


