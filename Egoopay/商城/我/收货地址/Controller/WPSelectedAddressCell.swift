//
//  WPSelectedAddressCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/18.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPSelectedAddressCellID = "WPSelectedAddressCellID"

class WPSelectedAddressCell: UITableViewCell {

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
        
        title_label.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title_label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        return label
    }()
    
    var provinceDic: NSDictionary! = nil {
        didSet {
            title_label.text = provinceDic["name"] as? String
        }
    }
    
    var cityDic: NSDictionary! = nil {
        didSet {
            title_label.text = cityDic["name"] as? String
        }
    }
    
    var areaDic: NSDictionary! = nil {
        didSet {
            title_label.text = areaDic["name"] as? String
        }
    }
    
    
    var provincesDic: NSDictionary! = nil {
        didSet {
            title_label.text = provincesDic["provinceName"] as? String
        }
    }
    
    var citysDic: NSDictionary! = nil {
        didSet {
            title_label.text = citysDic["cityName"] as? String
        }
    }
    
    var areasDic: NSDictionary! = nil {
        didSet {
            title_label.text = areasDic["areaName"] as? String
        }
    }
    
}


class WPSelectedAddressTitleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 45)
        self.backgroundColor = UIColor.tableViewColor()
        self.addSubview(title_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 15, y: 20, width: kScreenWidth - 30, height: 20))
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
}
