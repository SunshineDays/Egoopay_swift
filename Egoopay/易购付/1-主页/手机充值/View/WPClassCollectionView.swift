//
//  WPPhoneChargeFooterView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/16.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPClassCollectionView: UIView, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var titleFontSize = WPFontDefaultSize
    
    var title_array = NSArray()
    var image_array = NSArray()
    
    var icon_count = CGFloat()
    
    func initData(iconCount: CGFloat, titleArray: NSArray, imageArray: NSArray) {
        title_array = titleArray
        image_array = imageArray
        icon_count = iconCount
        self.addSubview(collectionView)
        self.frame.size.height = collectionView.frame.height
    }
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth / self.icon_count, height: 90)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(self.frame.size.height - 105, 0, 15, 0)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        return flowLayout
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.frame.size.height), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPHomeClassCell", bundle: nil), forCellWithReuseIdentifier: WPHomeClassCellID)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPHomeClassCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPHomeClassCellID, for: indexPath) as! WPHomeClassCell
        cell.title_imageView.image = image_array[indexPath.row] as? UIImage
        cell.title_label.text = title_array[indexPath.row] as? String
        cell.title_label.font = UIFont.systemFont(ofSize: titleFontSize)
        return cell
    }
}
