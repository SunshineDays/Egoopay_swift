//
//  WPEShopDetailSpecificationModel.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/25.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopDetailSpecificationModel: NSObject {

    @objc var required = NSInteger()
    
    @objc var product_option_value = NSArray()
    
    @objc var value = String()
    
    @objc var type = String()
    
    @objc var product_option_id = NSInteger()
    
    @objc var option_id = NSInteger()
    
    @objc var name = String()

}


class WPEShopDetailSpecificationProductModel: NSObject {
    
    @objc var subtract = NSInteger()
    
    @objc var quantity = NSInteger()
    
    @objc var price_prefix = String()
    
    @objc var weight = Float()
    
    @objc var price = Float()
    
    @objc var weight_prefix = String()
    
    @objc var image = String()
    
    @objc var product_option_value_id = NSInteger()
    
    @objc var option_value_id = NSInteger()
    
    @objc var name = String()
    
}


