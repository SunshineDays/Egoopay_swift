//
//  WPEShopLogisticsModel.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopLogisticsModel: NSObject {

    @objc var LogisticCode = String()
    
    @objc var ShipperCode = String()

    @objc var State = String()

    @objc var shipping_method = String()
    
    @objc var Traces = NSArray()
    
}

class WPEShopLogisticsTracesModel: NSObject {
    
    @objc var AcceptStation = String()
    
    @objc var AcceptTime = String()
}
