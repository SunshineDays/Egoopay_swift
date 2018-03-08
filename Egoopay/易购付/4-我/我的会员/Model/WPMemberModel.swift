//
//  WPMemberModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/10.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPMemberModel: NSObject {
    
    @objc var lvname = String()
    
    @objc var pointRate = Float()

    @objc var rate = Float()
    
    @objc var id = NSInteger()
    
    @objc var price = Float()

    @objc var mdesp = String()
    
    @objc var txFee = NSInteger()

    @objc var tradeType = NSInteger()
    
    @objc var levelNo = NSInteger()
    
    @objc var chanelMessage = NSMutableArray()
    
    @objc var descMsg = String()
    
    @objc var subNumber = NSInteger()
    
    @objc var moreInvite = NSInteger()
}

class WPMemberChannelModel: NSObject {
    
    @objc var chanelId = NSInteger()
    
    @objc var txFee = Float()
    
    @objc var mdesp = String()
    
    @objc var chanleName = String()
    
    @objc var rate = Float()
}
