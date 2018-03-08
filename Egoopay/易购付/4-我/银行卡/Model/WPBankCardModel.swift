//
//  WPBankCardModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBankCardModel: NSObject {

    @objc var id = NSInteger()
    
    @objc var lastNumber = String()
    
    @objc var extCardType = NSInteger()
    
    @objc var phone = NSInteger()
    
    @objc var bankName = String()
    
    @objc var isReceive = NSInteger()
    
    @objc var bankCode = String()
    
    @objc var identityCard = String()
    
    @objc var identifyName = String()
    
    @objc var cardType = NSInteger()
    
    @objc var isPicConfirm = NSInteger()
    
    @objc var year = String()
    
    @objc var bandDate = String()
    
    @objc var month = String()
    
    @objc var merId = String()
    
    @objc var bankId = NSInteger()
    
    @objc var auditStatus = NSInteger()
    
    @objc var isDelete = NSInteger()
    
    class func loadData(clitype: String, success: @escaping (_ dataArray : [Any]) -> (), failure: @escaping (_ error : Any) -> ()) {
        WPDataTool.GETRequest(url: WPUserBanKCardURL, parameters: ["cardType" : clitype],  success: { (result) in
            success(WPBankCardModel.mj_objectArray(withKeyValuesArray: result["cardList"] as! NSArray) as! [Any])
        }) { (error) in
            failure(error)
        }
    }
    
    
}
