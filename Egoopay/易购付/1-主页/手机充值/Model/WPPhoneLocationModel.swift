//
//  WPPhoneLocationModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/11.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPhoneLocationModel: NSObject {
    
    @objc var province = String()
    
    @objc var contractor = String()
    
    @objc var city = String()
    
    @objc var rechargeType = String()
    
    @objc var list = NSArray()
    
}


class WPPhoneProductModel: NSObject {
    
    @objc var resultValue = NSInteger()
    
    @objc var id = NSInteger()
    
    @objc var price = Float()
    
    @objc var productType = String()
    
    @objc var tradeType = NSInteger()
}
