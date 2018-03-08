//
//  WPEShopHomePageHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/23.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopHomePageHeaderView: UIView, SDCycleScrollViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: scrollerView_hieght + 60)
        self.addSubview(scrollView)
        initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initScrollViewImageArray(array: NSMutableArray) {
        scrollView.imageURLStringsGroup = array as! [Any]
        scrollView.reloadInputViews()
    }
    
    /**  轮播图高度 */
    let scrollerView_hieght: CGFloat = kScreenWidth * 584 / 1080
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: self.scrollerView_hieght)
        scrollView.backgroundColor = UIColor.white
        scrollView.bannerImageViewContentMode = UIViewContentMode.scaleAspectFill
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.delegate = self
        return scrollView
    }()
    
    func initButtons() {
        let titles = [" 优鲜严选", " 安心检测", " 赔付保障"]
        let images = [#imageLiteral(resourceName: "icon_eshop_homePage_titleA"), #imageLiteral(resourceName: "icon_eshop_homePage_titleB"), #imageLiteral(resourceName: "icon_eshop_homePage_titleC")]
        for i in 0 ..< titles.count {
            let button = UIButton.init(frame: CGRect.init(x: kScreenWidth / 3 * CGFloat(i), y: scrollView.frame.maxY + 15, width: kScreenWidth / 3, height: 30))
            button.setTitle(titles[i], for: .normal)
            button.setImage(images[i], for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(button)
        }
    }
    
}
