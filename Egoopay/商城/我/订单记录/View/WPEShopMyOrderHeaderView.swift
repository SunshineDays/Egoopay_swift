//
//  WPEShopMyOrderHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyOrderHeaderView: UIView, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initInfor(showNumber: CGFloat, selectedNumber: Int, titleArray: [String]) {
        
        self.showNumber = showNumber
        self.title_array = titleArray
        for i in 0 ..< titleArray.count {
            self.viewColors.add(i == selectedNumber ? UIColor.themeEShopColor() : UIColor.clear)
        }
        collectionView.reloadData()
        let indexPath = IndexPath.init(row: selectedNumber, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    var title_array = [String]()

    let viewColors = NSMutableArray()
    
    /**  一行展示个数 */
    var showNumber = CGFloat()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.frame.size.height), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPEShopMyOrderHeaderCell", bundle: nil), forCellWithReuseIdentifier: WPEShopMyOrderHeaderCellID)
        self.addSubview(collectionView)
        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: kScreenWidth / showNumber, height: self.frame.size.height)
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
        let cell: WPEShopMyOrderHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopMyOrderHeaderCellID, for: indexPath) as! WPEShopMyOrderHeaderCell
        cell.title_label.text = title_array[indexPath.row]
        cell.title_label.textColor = ((viewColors[indexPath.row] as? UIColor) == UIColor.themeEShopColor()) ? UIColor.themeEShopColor() : UIColor.darkGray
        cell.title_view.backgroundColor = viewColors[indexPath.row] as? UIColor
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
    
}
