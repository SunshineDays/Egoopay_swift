//
//  WPEShopPayResultSuccessCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/16.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopPayResultSuccessCellID = "WPEShopPayResultSuccessCellID"

class WPEShopPayResultSuccessCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        title_imageView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(100)
        })
        
        line_view.snp.makeConstraints { (make) in
            make.top.equalTo(title_imageView.snp.bottom).offset(30)
            make.left.equalTo(contentView).offset(WPLeftMargin)
            make.right.equalTo(contentView).offset(-WPLeftMargin)
            make.height.equalTo(WPLineHeight)
        }
        
        goHome_button.snp.makeConstraints { (make) in
            make.top.equalTo(line_view.snp.bottom).offset(30)
            make.right.equalTo(contentView.snp.centerX).offset(-20)
            make.width.equalTo(120)
            make.height.equalTo(45)
        }
        
        lookOrder_button.snp.makeConstraints { (make) in
            make.top.equalTo(line_view.snp.bottom).offset(30)
            make.left.equalTo(contentView.snp.centerX).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(45)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title_imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icon")
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var line_view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lineColor()
        contentView.addSubview(view)
        return view
    }()
    
    lazy var goHome_button: UIButton = {
        let button = UIButton()
        button.setTitle("返回首页", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderColor = UIColor.lineColor().cgColor
        button.layer.borderWidth = WPLineHeight
        contentView.addSubview(button)
        return button
    }()
    
    lazy var lookOrder_button: UIButton = {
        let button = UIButton()
        button.setTitle("查看订单", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderColor = UIColor.lineColor().cgColor
        button.layer.borderWidth = WPLineHeight
        contentView.addSubview(button)
        return button
    }()
    
}
