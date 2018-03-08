//
//  WPHomePageHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/3/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPHomePageHeaderView: UIView, SDCycleScrollViewDelegate, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(scrollView)
        collectionViewA.reloadData()
        collectionViewB.reloadData()
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: scrollView.frame.height + collectionViewA.frame.height + collectionViewB.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let arrayA = [[#imageLiteral(resourceName: "icon_n"), #imageLiteral(resourceName: "icon_s")], ["收款", "信用卡取现"], ["多码合一 一码收款", "支付新时代 便捷"], [UIColor.colorConvert(colorString: "F4F6FC"), UIColor.colorConvert(colorString: "F7F6F1")]]
    
    let arrayB = [[#imageLiteral(resourceName: "icon_b"), #imageLiteral(resourceName: "icon_xinyongkashenqi"), #imageLiteral(resourceName: "icon_xiaoedaikuan"), #imageLiteral(resourceName: "icon_eShop"), #imageLiteral(resourceName: "icon_c"), #imageLiteral(resourceName: "icon_a"), #imageLiteral(resourceName: "icon_d")], ["账单", "信用卡申请", "小额贷款", "商城", "手机充值", "商家", "提现"]]
    
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 570 / 1080)
        scrollView.bannerImageViewContentMode = .scaleAspectFill
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var flowLayoutA: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kScreenWidth - 20) / 2, height: 90)
//        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 0, 5)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var collectionViewA: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: self.scrollView.frame.maxY, width: kScreenWidth, height: 100), collectionViewLayout: self.flowLayoutA)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPHomePageTitleButtonCell", bundle: nil), forCellWithReuseIdentifier: WPHomePageTitleButtonCellID)
        self.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var flowLayoutB: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth / 5, height: 90)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var collectionViewB: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: self.collectionViewA.frame.maxY, width: kScreenWidth, height: (kScreenWidth / 5 - 36) + 55), collectionViewLayout: self.flowLayoutB)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPHomePageContentCell", bundle: nil), forCellWithReuseIdentifier: WPHomePageContentCellID)
        self.addSubview(collectionView)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionViewA ? arrayA[0].count : arrayB[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewA {
            let cell: WPHomePageTitleButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPHomePageTitleButtonCellID, for: indexPath) as! WPHomePageTitleButtonCell
            cell.title_imageView.image = arrayA[0][indexPath.row] as? UIImage
            cell.titleA_label.text = arrayA[1][indexPath.row] as? String
            cell.titleB_label.text = arrayA[2][indexPath.row] as? String
            cell.backgroundColor = arrayA[3][indexPath.row] as? UIColor
            return cell
        }
        else {
            let cell: WPHomePageContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPHomePageContentCellID, for: indexPath) as! WPHomePageContentCell
            cell.title_iamgeView.image = arrayB[0][indexPath.row] as? UIImage
            cell.title_label.text = arrayB[1][indexPath.row] as? String
            return cell
        }
    }
}
