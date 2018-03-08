//
//  WPEShopShopDetailHeaderCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/17.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopShopDetailHeaderCellID = "WPEShopShopDetailHeaderCellID"

class WPEShopShopDetailHeaderCell: UITableViewCell, SDCycleScrollViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headerImage_view.addSubview(scrollView)
//        scrollView.imageURLStringsGroup
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var headerImage_view: UIView!
    
    @IBOutlet weak var name_label: UILabel!
    
    @IBOutlet weak var price_label: UILabel!
    
    @IBOutlet weak var originPrice_label: UILabel!
    
    @IBOutlet weak var select_label: UILabel!
    
    @IBOutlet weak var select_button: UIButton!
    
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth))
        scrollView.backgroundColor = UIColor.white
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.bannerImageViewContentMode = .scaleAspectFill
        scrollView.autoScroll = false
        scrollView.infiniteLoop = false
        scrollView.delegate = self
        return scrollView
    }()
    
    
    var model: WPEShopShopDetailModel! = nil {
        didSet {
            scrollView.imageURLStringsGroup = model.image as! [Any]
            scrollView.reloadInputViews()
            name_label.text = model.name
            price_label.text = String(format: "￥%.2f", model.price)
            originPrice_label.text = String(format: "￥%.2f", model.price * 1.2)
        }
    }
}


let WPEShopShopDetailImageCellID = "WPEShopShopDetailImageCellID"

class WPEShopShopDetailImageCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        scrollView.imageURLStringsGroup
        self.backgroundColor = UIColor.red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        content_imageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.left.equalTo(contentView.snp.left).offset(0)
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    lazy var content_imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        return imageView
    }()
    
    
    var model:  WPEShopShopDetailModel! = nil {
        didSet {
            
        }
    }
    
}




