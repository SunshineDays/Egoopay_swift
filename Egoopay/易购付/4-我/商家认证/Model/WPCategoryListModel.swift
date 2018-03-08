//
//  WPCategoryListModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/28.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPCategoryListModel: NSObject {

    @objc var id = NSInteger()
    
    @objc var name = String()
    
    @objc var sort = String()
    
    /** 获取商户分类 */
    class func loadData(success : @escaping (_ dataArray : [Any]) -> ()) {
        WPDataTool.GETRequest(url: WPGetCategoryURL, parameters: nil, success: { (result) in
            success(WPCategoryListModel.mj_objectArray(withKeyValuesArray: result["cateList"] as! NSArray) as! [Any])
        }) { (error) in
            
        }
    }
    
}
