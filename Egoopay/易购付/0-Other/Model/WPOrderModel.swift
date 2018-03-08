//
//  WPOrderModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/9.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPOrderResultModel: NSObject {
    
    @objc var orderId = NSInteger()
    
    @objc var order = NSDictionary()
}


class WPOrderModel: NSObject {

    @objc var id = NSInteger()
    
    @objc var avl_amount = Float()
    
    @objc var productId = NSInteger()
    
    @objc var inPaystate = NSInteger()
    
    @objc var amount = Float()
    
    @objc var createDate = String()
    
    @objc var payState = NSInteger()
    
    @objc var counterFee = Float()
    
    @objc var orderno = String()
    
    @objc var tradeType = NSInteger()
    
    @objc var counterRate = NSInteger()
    
    @objc var merchantid = NSInteger()
    
    @objc var frozen = NSInteger()
    
    @objc var remark = String()
    
    @objc var ip = String()
    
    @objc var showNews = NSInteger()
    
    @objc var refund = NSInteger()
    
    @objc var userlvid = NSInteger()
    
}
