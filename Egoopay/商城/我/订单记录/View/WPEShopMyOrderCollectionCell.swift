//
//  WPEShopMyOrderCollectionCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyOrderCollectionCellID = "WPEShopMyOrderCollectionCellID"

class WPEShopMyOrderCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 2
        title_imageView.layer.cornerRadius = 2
        title_imageView.layer.masksToBounds = true
    }

    @IBOutlet weak var title_imageView: UIImageView!
    
    var model: WPEShopProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
        }
    }
    
    
    var shopModel: WPEShopMyOrderListProductsModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: shopModel.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
        }
    }
    
}
