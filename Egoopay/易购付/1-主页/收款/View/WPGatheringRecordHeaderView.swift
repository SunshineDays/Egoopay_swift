//
//  WPGatheringRecordHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/9.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPGatheringRecordHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 150)
        self.backgroundColor = UIColor.tableViewColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initInfor(title: String, money: String) {
        self.title = title
        self.money = money
        self.addSubview(theme_view)
        
        theme_view.addSubview(panel_view)
        
        panel_view.addSubview(title_label)
        panel_view.addSubview(money_label)
    }
    
    var title = String()
    
    var money = String()
    
    lazy var theme_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100))
        view.backgroundColor = UIColor.themeColor()
        return view
    }()
    
    lazy var panel_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: WPLeftMargin, y: 15, width: kScreenWidth - 2 * WPLeftMargin, height: 120))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = WPCornerRadius
        view.layer.shadowColor = UIColor.themeColor().cgColor
        view.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        view.layer.shadowOpacity = 0.7
        return view
    }()
    
    lazy var title_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: (kScreenWidth - 2 * WPLeftMargin) / 2 - 100, y: 0, width: 200, height: 40))
        label.text = self.title
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var money_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: (kScreenWidth - 2 * WPLeftMargin) / 2 - 100, y: self.title_label.frame.maxY, width: 200, height: 50))
        label.text = self.money
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 1))
        label.textAlignment = .center
        return label
    }()
    
    
}
