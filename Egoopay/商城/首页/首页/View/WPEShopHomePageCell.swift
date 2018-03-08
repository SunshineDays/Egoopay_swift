//
//  WPEShopHomePageCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopHomePageCellID = "WPEShopHomePageCellID"

class WPEShopHomePageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    @IBOutlet weak var cart_button: UIButton!
    
    var model: WPEShopProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.image))
            title_label.text = model.name
            price_label.text = String(format: "￥%.2f", model.price)
        }
    }
}
