//
//  WPEShopMyOrderDetailModel.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/30.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyOrderDetailModel: NSObject {

    @objc var shipping_method = String()
    
    @objc var order_info_id = String()
    
    @objc var shipping_country = String()
    
    @objc var shipping_city = String()
    
    @objc var shipping_zone = String()
    
    @objc var shipping_address_1 = String()
    
    @objc var comment = String()
    
    @objc var date_modified = String()
    
    @objc var date_added = String()
    
    @objc var shipping_firstname = String()
    
    @objc var telephone = String()
    
    @objc var total = Double()
    
    @objc var payment_method = String()
    
    @objc var order_status = String()
    
    @objc var products = NSArray()
    
    @objc var order_id = String()
    
}

class WPEShopMyOrderDetailProductModel: NSObject {
    
    @objc var product_id = NSInteger()
    
    @objc var quantity = NSInteger()
    
    @objc var price = Double()
    
    @objc var image = String()
    
    @objc var total = Double()
    
    @objc var name = String()
    
    @objc var options = NSArray()

}

class WPEShopMyOrderDetailProductOptionsModel: NSObject {
    
    @objc var name = String()
    
    @objc var value = String()
    
}

