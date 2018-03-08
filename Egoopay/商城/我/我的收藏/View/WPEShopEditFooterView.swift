//
//  WPEShopEditFooterView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopEditFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(line_view)
        self.addSubview(select_button)
        self.addSubview(total_label)
        self.addSubview(edit_button)
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
//        button.addTarget(self, action: #selector(self.selectAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var total_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: self.select_button.frame.maxX + 5, y: 0, width: 30, height: 55))
        label.text = "全选"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    lazy var edit_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 120, y: 0, width: 120, height: 55))
        button.backgroundColor = UIColor.red
        button.setTitle("取消关注", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    var isSelect = false
    
//    @objc func selectAction(_ button: UIButton) {
//        isSelect = !isSelect
//        button.setImage(isSelect ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
//    }
    
}
