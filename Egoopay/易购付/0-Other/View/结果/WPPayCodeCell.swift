//
//  WPPayCodeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/9.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPPayCodeCellID = "WPPayCodeCellID"

class WPPayCodeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        code_width.constant = kScreenWidth * 3 / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var finish_button: UIButton!
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var code_imageView: UIImageView!
    
    @IBOutlet weak var save_button: UIButton!
    
    @IBOutlet weak var code_width: NSLayoutConstraint!
    
    var model: WPPayCodeModel! = nil {
        didSet {
            var title = String()
            var image = UIImage()
            switch model.method {
            case 2:
                title = "微信"
                image = #imageLiteral(resourceName: "icon_wechatLine")
            case 3:
                title = "支付宝"
                image = #imageLiteral(resourceName: "icon_alipyLine")
            default:
                title = "QQ"
                image = #imageLiteral(resourceName: "icon_qqLine")
            }
            
            title_label.text = "请先保存二维码图片，在" + title + "中扫描支付"
            
            code_imageView.image = SGQRCodeTool.sg_generate(withLogoQRCodeData: model.codeUrl, logoImage: image, logoScaleToSuperView: 0.2)
        }
    }
    
}
