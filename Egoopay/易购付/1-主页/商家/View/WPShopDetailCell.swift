//
//  WPShopDetailCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPShopDetailCellID = "WPShopDetailCellID"

class WPShopDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        title_imageView.layer.cornerRadius = WPCornerRadius
        title_imageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var shopName_label: UILabel!
    
    @IBOutlet weak var shopBoss_label: UILabel!
    
    @IBOutlet weak var shopAddress_button: UIButton!
    
    @IBOutlet weak var shopTel_button: UIButton!
    
    @IBOutlet weak var shopDescp_label: UILabel!
    
    
    var model: WPShopDetailModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.shopCover_url != "" ? model.shopCover_url : model.cover_url), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"), options: .refreshCached)
            
            shopName_label.text = model.shopName
            shopBoss_label.text = model.linkMan
            
            let city = (model.province == model.city ? "" : model.province) + model.city + model.area + model.detailAddr
            shopAddress_button.setTitle(city, for: .normal)

            shopTel_button.setTitle(model.telephone, for: .normal)
            
            shopDescp_label.text = model.descp == "" ? model.desct : model.descp
        }
    }
    
}
