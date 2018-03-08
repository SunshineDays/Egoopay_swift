//
//  WPEShopMyOrderOnlyOneCollectionCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyOrderOnlyOneCollectionCellID = "WPEShopMyOrderOnlyOneCollectionCellID"

class WPEShopMyOrderOnlyOneCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var title_iamgeView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var number_label: UILabel!
    
    var model: WPEShopMyOrderListProductsModel! = nil {
        didSet {
            title_iamgeView.sd_setImage(with: URL.init(string: model.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
            title_label.text = model.name
            let array = NSMutableArray()
            array.addObjects(from: WPEShopMyOrderListProductsOptionsModel.mj_objectArray(withKeyValuesArray: model.options) as! [Any])
            var title = String()
            for m in array {
                let listModel = m as! WPEShopMyOrderListProductsOptionsModel
                title = title + listModel.name + ":" + listModel.value + " "
            }
            content_label.text = title
        }
    }
    
    var number: NSInteger! = nil {
        didSet {
            number_label.text = String(format: "x%d", number)
        }
    }
}
