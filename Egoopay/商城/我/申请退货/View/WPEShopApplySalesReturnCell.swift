//
//  WPEShopApplySalesReturnCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/15.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopApplySalesReturnCellID = "WPEShopApplySalesReturnCellID"

class WPEShopApplySalesReturnCell: UITableViewCell, UITextViewDelegate, UICollectionViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        confirm_button.layer.cornerRadius = WPCornerRadius
        
        desc_textView.delegate = self
        
        image_array.add(#imageLiteral(resourceName: "icon_eShop_evaluate_camera"))
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var payMoney_label: UILabel!
    
    @IBOutlet weak var returnMoney_label: UILabel!
    
    @IBOutlet weak var desc_textView: UITextView!
    
    @IBOutlet weak var desc_label: UILabel!
    
    @IBOutlet weak var camera_view: UIView!
    
    @IBOutlet weak var confirm_button: UIButton!
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range == NSRange.init(location: 0, length: 1) || (range == NSRange.init(location: 0, length: 0) && text == "") {
            desc_label.isHidden = false
        }
        else {
            desc_label.isHidden = true
        }
        return true
    }
    
    
    let image_array = NSMutableArray()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.camera_view.frame.size.height), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPEShopMyOrderCollectionCell", bundle: nil), forCellWithReuseIdentifier: WPEShopMyOrderCollectionCellID)
        self.camera_view.addSubview(collectionView)
        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: self.camera_view.frame.size.height - 20, height: self.camera_view.frame.size.height - 20)
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    // MARK: - UICollectionViewDataSoure
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPEShopMyOrderCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopMyOrderCollectionCellID, for: indexPath) as! WPEShopMyOrderCollectionCell
        cell.title_imageView.image = (image_array[image_array.count - indexPath.row - 1] as! UIImage)
        cell.layer.borderColor = UIColor.lineColor().cgColor
        cell.layer.borderWidth = WPLineHeight
        cell.layer.cornerRadius = WPCornerRadius
        return cell
    }
}
