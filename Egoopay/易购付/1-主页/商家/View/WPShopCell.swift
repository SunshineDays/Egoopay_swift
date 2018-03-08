//
//  WPShopCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/2.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPShopCellID = "WPShopCellID"

class WPShopCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title_imageView.layer.cornerRadius = WPCornerRadius
        title_imageView.layer.masksToBounds = true
        title_imageView.frame.size.height = 60
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var address_label: UILabel!
    
    @IBOutlet weak var location_label: UILabel!
    
    
    var model: WPShopDetailModel! = nil {
        didSet {
            title_label.text = model.shopName
            title_imageView.sd_setImage(with: URL.init(string: model.shopCover_url), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"), options: .refreshCached)
            let city = (model.city == "市辖区" || model.city == "县") ? "" : model.city
//            let address = model.province != model.city ? ( model.province + city + model.area + model.detailAddr) : (city + model.area + model.detailAddr)
            
//            address_label.text = address
            
            address_label.text = model.desct
            
            location_label.text = model.area != "" ? model.area : (city != "" ? city : model.province)
        }
    }
}
