//
//  WPEShopSearchHotView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/11.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopSearchHotView: UIView, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(hot_label)
        self.addSubview(margin_view)
        self.addSubview(history_label)
        self.addSubview(clear_buton)
        self.addSubview(line_view)
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var hotSearch_array = ["明日叶", "土蜂蜜", "土鸡蛋", "小薏米"]
    
    lazy var hot_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 15, width: 100, height: 20))
        label.text = "热门搜索"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = kScreenWidth / 4 - 30
        flowLayout.itemSize = CGSize.init(width: width, height: 50 - 20)
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: self.hot_label.frame.maxY + 10, width: kScreenWidth, height: 50), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPEShopSearchHotCollectionCell", bundle: nil), forCellWithReuseIdentifier: WPEShopSearchHotCollectionCellID)
        self.addSubview(collectionView)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotSearch_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPEShopSearchHotCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopSearchHotCollectionCellID, for: indexPath) as! WPEShopSearchHotCollectionCell
        cell.title_label.text = hotSearch_array[indexPath.row]
        return cell
    }
    
    
    lazy var margin_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.collectionView.frame.maxY, width: kScreenWidth, height: 15))
        view.backgroundColor = UIColor.tableViewColor()
        return view
    }()
    
    lazy var history_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 15, y: self.margin_view.frame.maxY + 12, width: 100, height: 20))
        label.text = "历史搜索"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var clear_buton: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 15 - 20, y: self.margin_view.frame.maxY + 12, width: 20, height: 20))
        button.setImage(#imageLiteral(resourceName: "icon_clear_clear"), for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 0.5, width: kScreenWidth, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
}
