//
//  WPUserApproveModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/18.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserApproveModel: NSObject {

    @objc var fullName = String()
    
    @objc var identityCard = String()
    
    @objc var state = Int()
    
    @objc var infomation = String()
    
    /**  获取实名认证信息 */
    class func loadData(success : @escaping (_ model : WPUserApproveModel) -> (), failure : @escaping (_ error : Any) -> ()) {
        WPDataTool.GETRequest(url: WPUserApproveIDCardPassURL, parameters: ["" : ""], success: { (result) in
            success(WPUserApproveModel.mj_object(withKeyValues: result))
        }) { (error) in
            failure(error)
        }
    }
    
    
    
}
