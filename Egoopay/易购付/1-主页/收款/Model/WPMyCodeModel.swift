//
//  WPMyCodeModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/9.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPMyCodeModel: NSObject {

    @objc var picurl = String()
    
    @objc var isExistReceiveBank = String()

    @objc var qr_url = String()

}

class WPMyCodeResultModel: NSObject {
    @objc var todayQrIncome = Float()
}
