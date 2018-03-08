//
//  WPMessageDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPMessageDetailController: WPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "消息详情"
        scrollView.addSubview(title_label)
        scrollView.addSubview(content_label)
        scrollView.addSubview(date_label)
        scrollView.contentSize = CGSize(width: kScreenWidth, height: date_label.frame.maxY + 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var message_model = WPMessageSystemModel()
    
    lazy var scrollView: UIScrollView = {
        let tempScrollView = UIScrollView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        self.view.addSubview(tempScrollView)
        return tempScrollView
    }()

    lazy var title_label: UILabel = {
        let tempLabel = UILabel(frame: CGRect(x: WPLeftMargin, y: 10, width: WPButtonWidth, height: WPRowHeight))
        tempLabel.text = self.message_model.title
        tempLabel.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.numberOfLines = 0
        return tempLabel
    }()
    
    lazy var content_label: UILabel = {
        let content_string = self.message_model.content
        let tempLabel = UILabel(frame: CGRect(x: WPLeftMargin, y: self.title_label.frame.maxY, width: WPButtonWidth, height: WPPublicTool.getTextHeigh(textStr: content_string, fontSize: WPFontDefaultSize, width: WPButtonWidth)))
        tempLabel.text = content_string
        tempLabel.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.numberOfLines = 0
        return tempLabel
    }()
    
    lazy var date_label: UILabel = {
        let tempLabel = UILabel(frame: CGRect(x: WPLeftMargin, y: self.content_label.frame.maxY, width: WPButtonWidth, height: WPRowHeight))
        tempLabel.text = WPPublicTool.stringToDate(date: self.message_model.create_time)
        tempLabel.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        tempLabel.textAlignment = NSTextAlignment.right
        tempLabel.numberOfLines = 0
        return tempLabel
    }()
    
}
