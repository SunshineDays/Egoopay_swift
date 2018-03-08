//
//  WPEShopShopDetailImageShowView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/2.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopShopDetailImageShowView: UIView, SDCycleScrollViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UIGestureRecognizer.init(target: self, action: #selector(self.dismissView)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var image_array = NSArray()
    
    func initInfor(array: NSArray) {
        image_array = array
        scrollView.imageURLStringsGroup = image_array as! [Any]

        weak var weakSelf = self
        UIView.animate(withDuration: 2.0) {
            self.backgroundColor = UIColor.white
//            weakSelf?.scrollView.imageURLStringsGroup = weakSelf?.image_array as! [Any]!
            weakSelf?.scrollView.frame = CGRect.init(x: 0, y: (kScreenHeight - kScreenWidth) / 2, width: kScreenWidth, height: kScreenWidth)
        }
    }
    
    
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView.init(frame: CGRect.init(x: 10, y: (kScreenHeight - kScreenWidth) / 2, width: kScreenWidth / 4, height: kScreenWidth / 4))
        scrollView.backgroundColor = UIColor.clear
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.bannerImageViewContentMode = .scaleAspectFill
        scrollView.autoScroll = false
        scrollView.infiniteLoop = true
        scrollView.delegate = self
        self.addSubview(scrollView)
        return scrollView
    }()
    
    @objc func dismissView() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.scrollView.frame = CGRect.init(x: 10, y: (kScreenHeight - kScreenWidth) / 2, width: kScreenWidth / 4, height: kScreenWidth / 4)
            weakSelf?.alpha = 0
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
    
}
