//
//  WPUserInforModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserInforModel: NSObject {

    @objc var phone = String()
    
    @objc var accountBalance = Float()
    
    @objc var avl_balance = Float()
    
    @objc var nickname = String()
    
    /**  实名认证
     *   1:成功 2:失败 3:认证中
     */
    @objc var iscertified = NSInteger()
    
    /**  商家认证
     *   1:成功 2:失败 3:认证中
     */
    @objc var shopCertifyState = NSInteger()
    
    @objc var shopId = NSInteger()
    
    @objc var merchantlvid = NSInteger()
    
    @objc var type = String()
    
    @objc var merchantno = NSInteger()
    
    @objc var userName = String()
    
    @objc var fullName = String()
    
    @objc var sex = NSInteger()
    
    @objc var province = String()
    
    @objc var city = String()
    
    @objc var area = String()
    
    @objc var address = String()
    
    @objc var email = String()
    
    @objc var picurl = String()
    
    @objc var agentGradeId = NSInteger()
    
    @objc var rate = Float()
    
    @objc var depositeAmount = Float()
    
    class func loadData(success: @escaping (_ model: WPUserInforModel) -> (), failure: @escaping (_ error : Any) -> ()) {
        WPDataTool.GETRequest(url: WPUserInforURL, parameters: ["" : ""], success: { (result) in
            success(WPUserInforModel.mj_object(withKeyValues: result))
        }) { (error) in
            failure(error)
        }
    }
}
