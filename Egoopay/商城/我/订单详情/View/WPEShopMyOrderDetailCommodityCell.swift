//
//  WPEShopMyOrderDetailCommodityCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyOrderDetailCommodityCellID = "WPEShopMyOrderDetailCommodityCellID"

class WPEShopMyOrderDetailCommodityCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title_imageView.layer.masksToBounds = true
        title_imageView.layer.cornerRadius = WPCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var number_label: UILabel!
    
    @IBOutlet weak var money_label: UILabel!
    
    var model: WPEShopProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
            title_label.text = model.name
            money_label.text = String(format: "￥%.2f", model.price)
            number_label.text = String(format:"x%d", model.quantity)
            
            let array = NSMutableArray()
            array.addObjects(from: WPEShopShoppingCartOptionModel.mj_objectArray(withKeyValuesArray: model.options) as! [Any])
            var title = String()
            for m in array {
                let listModel = m as! WPEShopShoppingCartOptionModel
                title = title + listModel.name + ":" + listModel.value + " "
            }
            content_label.text = title
        }
    }
    
    /**  订单详情 */
    var detailModel: WPEShopMyOrderDetailProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: detailModel.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
            title_label.text = detailModel.name
            money_label.text = String(format: "￥%.2f", detailModel.price)
            number_label.text = String(format:"x%d", detailModel.quantity)
            
            let array = NSMutableArray()
            array.addObjects(from: WPEShopShoppingCartOptionModel.mj_objectArray(withKeyValuesArray: detailModel.options) as! [Any])
            var title = String()
            for m in array {
                let listModel = m as! WPEShopShoppingCartOptionModel
                title = title + listModel.name + ":" + listModel.value + " "
            }
            content_label.text = title
        }
    }
    
}
