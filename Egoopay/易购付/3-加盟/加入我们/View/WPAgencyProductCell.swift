//
//  WPAgencyProductCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPAgencyProductCellID = "WPAgencyProductCellID"

class WPAgencyProductCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    
    var model: WPAgencyProductAgUpListModel! = nil {
        didSet {
            title_imageView.image = WPInforTypeTool.userVipImage(agentGradeID: model.agentId)
            title_label.text = model.gradeName
            price_label.text = String(format: "￥%.2f", model.price)
        }
    }

}
