//
//  WPEShopShopDetailFooterView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/23.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopShopDetailFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(love_button)
        self.addSubview(cart_button)
        self.addSubview(addToCart_button)
        self.addSubview(line_view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initInfor(model: WPEShopProductModel) {
        
    }
    
    lazy var love_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width / 4, height: self.frame.height))
        button.setTitle("  收藏", for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_love_love"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy var cart_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.frame.width / 4, y: 0, width: self.frame.width / 4, height: self.frame.height))
        button.setTitle("  购物车", for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_cart_cart"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    
    lazy var addToCart_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.frame.width / 2, y: 0, width: self.frame.width / 2, height: self.frame.height))
        button.backgroundColor = UIColor.priceTextColor()
        button.setTitle("加入购物车", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
    
}
