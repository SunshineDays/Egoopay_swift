//
//  WPTitleView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/20.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPLeftAndRightButtonType = (_ leftButton : UIButton?, _ rightButton : UIButton?) -> Void

class WPTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
        self.isUserInteractionEnabled = true
        self.addSubview(title_label)
        self.addSubview(left_button)
        self.addSubview(right_button)
        self.addSubview(line_view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**  左右两边按钮点击事件 */
    var leftAndRightButtonType: WPLeftAndRightButtonType?
    
    lazy var title_label: UILabel = {
        let label = UILabel(frame: CGRect(x: kScreenWidth / 2 - 80, y: 20, width: 160, height: 43.5))
        label.text = "选择时间"
        label.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight(rawValue: 2))
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    lazy var left_button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 70, height: 43.5))
        button.setTitle("取消", for: UIControlState.normal)
        button.setTitleColor(UIColor.themeColor(), for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(self.leftButtonAction(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var right_button: UIButton = {
        let button = UIButton(frame: CGRect(x: kScreenWidth - 70, y: 20, width: 70, height: 43.5))
        button.setTitle("完成", for: UIControlState.normal)
        button.setTitleColor(UIColor.themeColor(), for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(self.rightButtonAction(_:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.left_button.frame.maxY, width: kScreenWidth, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
    @objc func leftButtonAction(_ button: UIButton) {
        leftAndRightButtonType?(button, nil)
    }
    
    @objc func rightButtonAction(_ button: UIButton) {
        leftAndRightButtonType?(nil, button)
    }
    
}
