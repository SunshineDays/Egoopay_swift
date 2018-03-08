//
//  WPShoppingCartEditView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShoppingCartEditView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(line_view)
        self.addSubview(select_button)
        self.addSubview(total_label)
        self.addSubview(delete_button)
        self.addSubview(love_button)
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
        let label = UILabel.init(frame: CGRect.init(x: self.select_button.frame.maxX + 5, y: 0, width: 200, height: 55))
        label.text = "全选"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var delete_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 10 - 65, y: 12.5, width: 65, height: 30))
        button.setTitle("删除", for: .normal)
        button.layer.cornerRadius = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy var love_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 10 - 65 - 10 - 65, y: 12.5, width: 65, height: 30))
        button.setTitle("移入关注", for: .normal)
        button.layer.cornerRadius = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
}
