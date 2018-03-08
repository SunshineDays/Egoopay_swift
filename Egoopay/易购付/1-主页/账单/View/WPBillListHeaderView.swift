//
//  WPBillListHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBillListHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.tableViewColor()
        self.isUserInteractionEnabled = true
        self.addSubview(title_label)
//        self.addSubview(select_button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title_label: UILabel = {
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 15, y: 0, width: 200, height: self.frame.size.height)
        return tempLabel
    }()
    
//    lazy var select_button: UIButton = {
//        let tempButton = UIButton()
//        tempButton.frame = CGRect(x: kScreenWidth - WPLeftMargin - 25, y: (self.frame.size.height - 25) / 2, width: 25, height: 25)
//        tempButton.setBackgroundImage(#imageLiteral(resourceName: "icon_rili"), for: .normal)
//        return tempButton
//    }()
}
