//
//  WPPopupTitleView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPopupTitleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cancel_image = UIImage()
    
    var title_string = String()
    
    func initInfor(title: String, cancelImage: UIImage) {
        self.cancel_image = cancelImage
        self.title_string = title
        self.addSubview(cancel_button)
        self.addSubview(title_label)
        self.addSubview(line_view)
    }
    
    lazy var cancel_button: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(cancel_image, for: .normal)
        return button
    }()
    
    lazy var title_label: UILabel = {
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: kScreenWidth / 2 - 100, y: 0, width: 200, height: 60 - 0.5)
        tempLabel.text = title_string
        tempLabel.font = UIFont.systemFont(ofSize: 19)
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    
    lazy var line_view: UIView = {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 59.5, width: kScreenWidth, height: WPLineHeight)
        tempView.backgroundColor = UIColor.lineColor()
        return tempView
    }()

}
