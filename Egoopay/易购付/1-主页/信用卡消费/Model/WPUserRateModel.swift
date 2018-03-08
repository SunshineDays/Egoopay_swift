//
//  WPUserRateModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserRateModel: NSObject {

    @objc var benefitRate = Float()
    
    @objc var commissionRate = Float()
    
    @objc var rate = Float()
    
    @objc var marking = String()
    
    @objc var fee_recharge = Float()
    
    class func getData(success : @escaping (_ model : WPUserRateModel) -> ()) {
        WPDataTool.GETRequest(url: WPPoundageURL, parameters: ["rateType" : "1"], success: { (result) in
            success(WPUserRateModel.mj_object(withKeyValues: result))
        }) { (error) in
            
        }
    }
    
}


