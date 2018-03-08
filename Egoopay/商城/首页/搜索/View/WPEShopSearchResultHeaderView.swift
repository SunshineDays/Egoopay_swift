//
//  WPEShopSearchResultHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/10.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopSearchResultHeaderView: UIView, UICollectionViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        color_array.addObjects(from: [UIColor.themeEShopColor(), UIColor.black, UIColor.black, UIColor.black])
        image_array.addObjects(from: [#imageLiteral(resourceName: "icon_eShop_search_default"), #imageLiteral(resourceName: "icon_eShop_search_default"), #imageLiteral(resourceName: "icon_eShop_search_default"), #imageLiteral(resourceName: "icon_eShop_search_default")])
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let title_array = ["全部", "销量", "价格", "新品"]
    
    let color_array = NSMutableArray()
    
    let image_array = NSMutableArray()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.frame.size.height), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPEShopSearchResultHeaderCell", bundle: nil), forCellWithReuseIdentifier: WPEShopSearchResultHeaderCellID)
        self.addSubview(collectionView)
        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: kScreenWidth / CGFloat(title_array.count), height: self.frame.size.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    // MARK: - UICollectionViewDataSoure
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPEShopSearchResultHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopSearchResultHeaderCellID, for: indexPath) as! WPEShopSearchResultHeaderCell
        cell.title_label.text = title_array[indexPath.row]
        cell.title_label.textColor = color_array[indexPath.row] as! UIColor
        if indexPath.row == 0 || indexPath.row == 3 {
            cell.title_iamgeView.isHidden = true
        }
        cell.title_iamgeView.image = image_array[indexPath.row] as? UIImage
        return cell
    }
    
    
}
