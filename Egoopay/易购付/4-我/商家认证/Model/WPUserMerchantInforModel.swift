//
//  WPUserMerchantInforModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/18.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserMerchantInforModel: NSObject {

    @objc var inside_imgUrls = NSArray()
    
    @objc var cover_url = String()
    
    @objc var descp = String()
    
    @objc var province = String()
    
    @objc var city = String()
    
    @objc var area = String()
    
    @objc var detailAddr = String()
    
    @objc var linkMan = String()
    
    @objc var linkMan_sex = String()
    
    @objc var other_img = String()
    
    @objc var shopName = String()
    
    @objc var telephone = String()
    
    @objc var status = Int()

    /**  获取商家认证信息 */
    class func loadData(success : @escaping (_ model : WPUserMerchantInforModel) -> (), failure : @escaping (_ error : Any) -> ()) {
        WPDataTool.GETRequest(url: WPQueryShopStatusURL, parameters: ["" : ""],  success: { (result) in
            success(WPUserMerchantInforModel.mj_object(withKeyValues: result))
        }) { (error) in
            failure(error)
        }
        
    }
    
    
}
