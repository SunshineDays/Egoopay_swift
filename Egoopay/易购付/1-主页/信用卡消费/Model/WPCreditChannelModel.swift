//
//  WPCreditChannelModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/12.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPCreditChannelModel: NSObject {

    @objc var id = NSInteger()
    
    @objc var message = String()
    
    @objc var minAmount = Float()
    
    @objc var fee = Float()
    
    @objc var endDate = String()
    
    @objc var settleMode = String()
    
    @objc var createTime = String()
    
    @objc var passType = NSInteger()
    
    @objc var fullName = String()
    
    @objc var maxAmount = Float()
    
    @objc var isOpen = NSInteger()
    
    @objc var startDate = String()
    
    @objc var rate = Float()
    
    @objc var name = String()
    
    @objc var flag = NSInteger()
    
}

class WPCreditChannelResultModel: NSObject {
    
    @objc var list = NSMutableArray()
    
}
