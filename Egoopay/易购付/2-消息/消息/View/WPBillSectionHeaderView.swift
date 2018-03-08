//
//  WPBillSectionHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBillSectionHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 37)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(title_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title_label: UILabel = {
        let temp_label = UILabel()
        temp_label.backgroundColor = UIColor.placeholderColor()
        temp_label.textColor = UIColor.white
        temp_label.textAlignment = NSTextAlignment.center
        temp_label.font = UIFont.systemFont(ofSize: 13)
        temp_label.layer.cornerRadius = WPCornerRadius
        temp_label.layer.masksToBounds = true
        return temp_label
    }()
    
    
    
}
