//
//  WPEShopShopDetaiEvaluateCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/1.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopShopDetaiEvaluateCellID = "WPEShopShopDetaiEvaluateCellID"

class WPEShopShopDetaiEvaluateCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var title_imageView: UIImageView!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var content_label: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    
    @IBOutlet weak var stars_view: UIView!
    
    
    lazy var starView: WPEvalutateStarShowView = {
        let view = WPEvalutateStarShowView()
        stars_view.addSubview(view)
        return view
    }()
 
    
    var model: WPEShopShopDetailEvaluateModel! = nil {
        didSet {
            title_imageView.sd_setImage(with: URL.init(string: model.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            name_label.text = WPPublicTool.stringStar(string: model.author, headerIndex: 3, footerIndex: 4)
            content_label.text = model.text.count > 0 ? model.text : "此用户没有填写评论！"
            time_label.text = model.date_added
            starView.starsNumber = model.rating
        }
    }
    
}
