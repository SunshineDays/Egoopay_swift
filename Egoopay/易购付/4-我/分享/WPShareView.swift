//
//  WPShareView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/12.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias ShareToAppType = (_ shareTitle : Any) -> Void

class WPShareView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.dismissShareView)))
        initShareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var shareToApp: ShareToAppType?
    
    let title_array = WPShareTool.shareTitleArray()
    let image_array = WPShareTool.shareImageArray()
    
    func initShareView() {
        
        self.addSubview(share_view)
        share_view.addSubview(collectionView)
        share_view.addSubview(cancel_button)
        share_view.addSubview(white_view)
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3) {
            let height: CGFloat = UIApplication.shared.statusBarFrame.size.height == 44 ? 34 : 0
            
            weakSelf?.share_view.frame = CGRect(x: 0, y: kScreenHeight - (weakSelf?.share_view.frame.height)! - height, width: kScreenWidth, height: (weakSelf?.share_view.frame.height)!)
        }
    }
    
    
    /**  分享面板 */
    lazy var share_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenWidth / 5 + 110))
        return view
    }()
    
    lazy var cancel_button: UIButton = {
        let tempButton = UIButton()
        tempButton.frame = CGRect(x: 0, y: self.share_view.frame.height - WPRowHeight + 1, width: self.share_view.frame.width, height: WPRowHeight - 1)
        tempButton.backgroundColor = UIColor.white
        tempButton.setTitle("取消", for: UIControlState.normal)
        tempButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        tempButton.addTarget(self, action: #selector(self.dismissShareView), for: UIControlEvents.touchUpInside)
        return tempButton
    }()
    
    lazy var white_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.cancel_button.frame.maxY, width: kScreenWidth, height: 34))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth / 5, height: kScreenWidth / 5 + 60)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth / 5 + 60), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPShareCell", bundle: nil), forCellWithReuseIdentifier: WPShareCellID)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPShareCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPShareCellID, for: indexPath) as! WPShareCell
        cell.title_imageView.image = image_array[indexPath.row] as? UIImage
        cell.title_label.text = title_array[indexPath.row] as? String
        cell.share_button.tag = indexPath.row
        cell.share_button.addTarget(self, action: #selector(self.shareAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.shareToApp?(self.title_array[indexPath.row])
        dismissShareView()
    }
    
    // MARK: - Action
    
    @objc func dismissShareView() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.share_view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 0)
            weakSelf?.alpha = 0
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
    
    @objc func shareAction(_ button: UIButton) {
        self.shareToApp?(self.title_array[button.tag])
        dismissShareView()
        
    }

    
    
    
}
