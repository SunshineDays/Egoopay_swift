//
//  WPTouchIDHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPTouchIDHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(touchID_imageView)
        self.addSubview(title_label)
        self.addSubview(protocol_label)
        self.addSubview(protocol_button)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: self.protocol_button.frame.maxY)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var touchID_imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: kScreenWidth / 2 - 50, y: WPTopY + 30, width: 100, height: 103))
        imageView.image = #imageLiteral(resourceName: "touchID")
        return imageView
    }()
    
    lazy var title_label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.touchID_imageView.frame.maxY, width: kScreenWidth, height: 30))
        label.text = "指纹密码只对本机有效"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    lazy var protocol_label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.title_label.frame.maxY, width: kScreenWidth / 2, height: 30))
        label.text = "开通即视为同意"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    lazy var protocol_button: UIButton = {
        let button = UIButton(frame: CGRect(x: kScreenWidth / 2, y: self.title_label.frame.maxY, width: kScreenWidth / 2, height: 30))
        button.setTitle("《易购付指纹相关协议》", for: UIControlState.normal)
        button.setTitleColor(UIColor.themeColor(), for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        return button
    }()
}
