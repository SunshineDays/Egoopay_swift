//
//  WPEShopMyOrderListModel.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/31.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyOrderListModel: NSObject {

    @objc var status = String()
    
    @objc var order_id = String()
    
    @objc var date_added = String()
    
    @objc var products = NSArray()
    
    @objc var order_info_id = String()
    
    @objc var amount = NSInteger()
    
    @objc var total = Double()
    
}

class WPEShopMyOrderListProductsModel: NSObject {
    
    @objc var product_id = NSInteger()
    
    @objc var options = NSArray()
    
    @objc var name = String()
    
    @objc var image = String()
    
}

class WPEShopMyOrderListProductsOptionsModel: NSObject {
    
    @objc var name = String()
    
    @objc var value = String()
    
}
