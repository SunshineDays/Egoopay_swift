//
//  WPEShopShoppingCartEmptyView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/24.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopShoppingCartEmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(25)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        title_label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.centerX.equalTo(self.snp.centerX)
        }
        go_button.snp.makeConstraints { (make) in
            make.top.equalTo(title_label.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(95)
            make.height.equalTo(35)
        }
        line_view.snp.makeConstraints { (make) in
            make.top.equalTo(go_button.snp.bottom).offset(30)
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icon_eShopShoppingCart_null")
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var title_label: UILabel = {
        let label = UILabel()
        label.text = "购物车空着哦～\n赶紧抢点儿东西慰劳自己吧～"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    
    lazy var go_button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.themeEShopColor()
        button.setTitle("去首页逛逛", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(button)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lineColor()
        self.addSubview(view)
        return view
    }()
    
}
