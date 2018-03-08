//
//  WPMyGatheringCodeCell.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPMyGatheringCodeCellID = "WPMyGatheringCodeCellID"

class WPMyGatheringCodeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        code_view.layer.cornerRadius = 6
        code_view.layer.masksToBounds = true
        
        today_view.layer.cornerRadius = 6
        today_view.layer.masksToBounds = true
        
        codeWidth_constraint.constant = kScreenWidth / 2
        
        code_imageView.layer.borderWidth = 6
        code_imageView.layer.borderColor = UIColor.white.cgColor
        code_imageView.layer.shadowColor = UIColor.themeColor().cgColor
        code_imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        code_imageView.layer.shadowOpacity = 0.7
        code_imageView.layer.shadowRadius = 15
        
        save_button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var code_view: UIView!
    
    @IBOutlet weak var codeWidth_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var code_imageView: UIImageView!
    
    @IBOutlet weak var money_label: UILabel!
    
    @IBOutlet weak var moneyHeight_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var set_button: UIButton!
    
    @IBOutlet weak var save_button: UIButton!
    
    @IBOutlet weak var today_view: UIView!
    
    @IBOutlet weak var record_button: UIButton!
    
    @IBOutlet weak var today_label: UILabel!
    
    @IBOutlet weak var today_button: UIButton!
    
    /**  是否显示设置的金额 */
    var isShow = false
    
    /**  设置金额的二维码图片 */
    var moneyCode_image = UIImage()
    
    /**  设置的金额 */
    var moneyNumber = String()
    
    var model: WPMyCodeModel! = nil {
        didSet {
            if isShow { //设置金额
                code_imageView.image = moneyCode_image
            }
            else { //固定收款码
                //获取用户头像
                var code_image = UIImage()
                code_image = SDImageCache.shared().imageFromCache(forKey: model.picurl) ?? #imageLiteral(resourceName: "icon_appIcon")
                //给用户头像添加白色边框
                code_image = SGQRCodeTool.addWatemarkImage(withLogoImage: #imageLiteral(resourceName: "background"), watemarkImage: code_image, logoImageRect: CGRect(x: 0, y: 0, width: 110, height: 110), watemarkImageRect: CGRect(x: 5, y: 5, width: 100, height: 100))
                //绘制二维码并添加logo(带有白色边框的用户头像)
                code_image = SGQRCodeTool.sg_generate(withLogoQRCodeData: model.qr_url, logoImage: code_image, logoScaleToSuperView: 0.2)
                code_imageView.image = code_image
            }
            
            moneyHeight_constraint.constant = isShow ? 70 : 0
            money_label.isHidden = !isShow
            money_label.text = isShow ? ("￥" + String(format: "%.2f", Float(moneyNumber)!)) : ""
            
            set_button.setTitle(isShow ? "清除金额" : "设置金额", for: .normal)
        }
    }
    
    
    /**  保存图片 */
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(code_imageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject) {
        if didFinishSavingWithError != nil
        {
            WPProgressHUD.showInfor(status: "二维码保存失败")
        }
        else {
            WPProgressHUD.showInfor(status: "二维码保存成功")
        }
    }
    
}
