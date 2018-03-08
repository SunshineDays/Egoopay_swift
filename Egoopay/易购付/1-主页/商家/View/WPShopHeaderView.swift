//
//  WPShopHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/2.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShopHeaderView: UIView, SDCycleScrollViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 300)
        self.addSubview(city_button)
        self.addSubview(searchBar)
        self.addSubview(scrollView)
        self.frame.size.height = self.scrollView.frame.maxY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var city_button: WPTitleImageButton = {
        let button = WPTitleImageButton.init(frame: CGRect.init(x: WPLeftMargin, y: 5, width: 60, height: 40))
        button.setTitle("城市", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(#imageLiteral(resourceName: "icon_xiajiatou"), for: .normal)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init(frame: CGRect.init(x: self.city_button.frame.maxX, y: 10, width: kScreenWidth - 60 - WPLeftMargin * 2, height: 30))
        searchBar.placeholder = "搜索商家"
        searchBar.layer.borderColor = UIColor.lineColor().cgColor
        searchBar.layer.borderWidth = WPLineHeight
        searchBar.backgroundColor = UIColor.clear
        searchBar.subviews[0].subviews[0].removeFromSuperview()
        return searchBar
    }()
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView()
        scrollView.frame = CGRect(x: 0, y: self.searchBar.frame.maxY + 10, width: self.frame.size.width, height: self.frame.size.width * 318 / 966)
        scrollView.bannerImageViewContentMode = UIViewContentMode.scaleToFill
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.delegate = self
        return scrollView
    }()

}
