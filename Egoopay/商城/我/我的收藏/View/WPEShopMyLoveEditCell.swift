//
//  WPEShopMyLoveEditCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyLoveEditCellID = "WPEShopMyLoveEditCellID"

class WPEShopMyLoveEditCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        select_button.isHidden = true
        imageSpaceConstraint.constant = -15
        cart_button.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var select_button: UIButton!
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var imageSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    @IBOutlet weak var cart_button: UIButton!
    
    var model: WPEShopProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.image))
            title_label.text = model.name
            price_label.text = String(format: "￥%.2f", model.price)
            select_button.setImage(model.isSelected == 1 ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        }
    }

    var isEdit: Bool! = nil {
        didSet {
            if isEdit {
                select_button.isHidden = false
                imageSpaceConstraint.constant = 10
                cart_button.isHidden = true
            }
            else {
                select_button.isHidden = true
                imageSpaceConstraint.constant = -25
                cart_button.isHidden = false
            }
        }
    }
    

}
