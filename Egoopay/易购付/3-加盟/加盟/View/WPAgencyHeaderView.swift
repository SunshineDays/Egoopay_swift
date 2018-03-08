//
//  WPAgencyHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/2.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAgencyHeaderView: UIView, SDCycleScrollViewDelegate, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(today: Float, balance: Float) {
        self.today = today
        self.balance = balance
        
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 300)
        self.addSubview(scrollView)
        self.addSubview(collectionView)
        self.frame.size.height = self.collectionView.frame.maxY
    }
    
    /**  今日分润 */
    var today = Float()
    
    /**  分润余额 */
    var balance = Float()
    
    let title_array = ["今日分润", "分润余额"]
    
    let width = (kScreenWidth - 160) / 2
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width * 514 / 961)
        scrollView.bannerImageViewContentMode = UIViewContentMode.scaleToFill
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.width, height: self.width)
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 50, 15, 50)
        flowLayout.minimumLineSpacing = 60
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y:self.scrollView.frame.maxY, width: kScreenWidth, height: self.width + 30), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.backgroundColor()
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPAgencyHeaderCell", bundle: nil), forCellWithReuseIdentifier: WPAgencyHeaderCellID)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPAgencyHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPAgencyHeaderCellID, for: indexPath) as! WPAgencyHeaderCell
        cell.title_label.text = title_array[indexPath.row]
        cell.money_label.text = String(format: "%.2f", indexPath.row == 0 ? today : balance)
        return cell
    }
    

}
