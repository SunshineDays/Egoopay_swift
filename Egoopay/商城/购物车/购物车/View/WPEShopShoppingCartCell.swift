//
//  WPEShopShoppingCartCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopShoppingCartCellID = "WPEShopShoppingCartCellID"

class WPEShopShoppingCartCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        minus_button.layer.borderColor = UIColor.lineColor().cgColor
        minus_button.layer.borderWidth = WPLineHeight
        
        add_button.layer.borderColor = UIColor.lineColor().cgColor
        add_button.layer.borderWidth = WPLineHeight
        
        number_textField.layer.borderColor = UIColor.lineColor().cgColor
        number_textField.layer.borderWidth = WPLineHeight
                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var select_button: UIButton!
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    @IBOutlet weak var minus_button: UIButton!
    
    @IBOutlet weak var add_button: UIButton!
    
    @IBOutlet weak var number_textField: UITextField!
    
    
    var model: WPEShopProductModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.image), placeholderImage: #imageLiteral(resourceName: "icon_shopDefaultPic"))
            title_label.text = model.name
            price_label.text = String(format: "￥%.2f", model.price)
            select_button.setImage(model.isSelected == 1 ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
            number_textField.text = String(format:"%d", model.quantity)
            
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
    
}
