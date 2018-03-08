//
//  WPEShopShopDetailCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/16.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopShopDetailCellID = "WPEShopShopDetailCellID"

class WPEShopShopDetailCell: UITableViewCell, SDCycleScrollViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        shopName_label.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
        }
        
        price_label.snp.makeConstraints { (make) in
            make.top.equalTo(shopName_label.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(15)
        }
     
        originalPrice_label.snp.makeConstraints { (make) in
            make.top.equalTo(price_label.snp.bottom).offset(15)
            make.left.equalTo(contentView).offset(15)
        }
        
        line_view.snp.makeConstraints { (make) in
            make.left.equalTo(originalPrice_label.snp.left).offset(50)
            make.centerY.equalTo(originalPrice_label.snp.centerY)
            make.right.equalTo(originalPrice_label.snp.right)
            make.height.equalTo(WPLineHeight)
        }
        
        lineA_view.snp.makeConstraints { (make) in
            make.top.equalTo(originalPrice_label.snp.bottom).offset(15)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        lineB_view.snp.makeConstraints { (make) in
            make.top.equalTo(originalPrice_label.snp.bottom).offset(15)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth))
        scrollView.bannerImageViewContentMode = .scaleToFill
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var shopName_label: UILabel = {
        let label = UILabel()
        label.text = "我是一只粉刷匠，粉刷本领强，我是一只粉刷匠，粉刷本领强，我是一只粉刷匠，粉刷本领强，我是一只粉刷匠，粉刷本领强，我是一只粉刷匠，粉刷本领强"
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        contentView.addSubview(label)
        return label
    }()
    
    
    lazy var price_label: UILabel = {
        let label = UILabel()
        label.text = "￥1908.45"
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 2))
        label.numberOfLines = 0
        contentView.addSubview(label)
        return label
    }()
    
    lazy var originalPrice_label: UILabel = {
        let label = UILabel()
        label.text = "市场价￥2289.09元"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 2))
        label.numberOfLines = 0
        contentView.addSubview(label)
        return label
    }()
    
    lazy var line_view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        contentView.addSubview(view)
        return view
    }()
    
    lazy var lineA_view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewColor()
        contentView.addSubview(view)
        return view
    }()
    
    
    lazy var lineB_view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewColor()
        contentView.addSubview(view)
        return view
    }()
    
}
