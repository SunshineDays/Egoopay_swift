//
//  WPEShopLogisticsView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopLogisticsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 92)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: WPEShopLogisticsModel! = nil {
        didSet {
            initLabels()
            self.addSubview(line_view)
        }
    }
    
    var image_url: String! = nil {
        didSet {
            title_iamgeView.sd_setImage(with: URL.init(string: image_url), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
        }
    }
    
    lazy var title_iamgeView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: 15, y: 15, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    
    func initLabels() {
        for i in 0 ..< 2 {
            let label = UILabel.init(frame: CGRect.init(x: self.title_iamgeView.frame.maxX + 10, y: 15 + 25 * CGFloat(i), width: kScreenWidth - 80, height: 25))
            label.textColor = UIColor.darkGray
            label.text = i == 0 ? ("承运来源：" + model.shipping_method) : ("运单编号：" + model.LogisticCode)
            label.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(label)
        }
    }
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.title_iamgeView.frame.maxY + 15, width: kScreenWidth, height: 12))
        view.backgroundColor = UIColor.tableViewColor()
        return view
    }()
    
}
