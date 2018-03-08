//
//  WPAgencyProductModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAgencyProductResultModel: NSObject {
    
    @objc var depositAmount = Float()
    
    @objc var agUpList = NSMutableArray()
    
}

class WPAgencyProductAgUpListModel: NSObject {
    
    @objc var depositAmt = Float()
    
    @objc var chanelMessage = NSMutableArray()
    
    @objc var commissionRate = Float()

    @objc var gradeName = String()

    @objc var price = Float()

    @objc var agentId = NSInteger()

    @objc var adesp = String()

    @objc var tradeType = NSInteger()
    
}

class WPAgencyProductChanelMessageModel: NSObject {
    
    @objc var descMessage = String()
    
    @objc var chanelId = NSInteger()
    
    @objc var benefitRate = Float()
    
    @objc var chanleName = String()
}


