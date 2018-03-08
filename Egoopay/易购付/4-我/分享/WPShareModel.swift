//
//  WPShareModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/13.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShareModel: NSObject {

    @objc var share_despt = String()
    
    @objc var title = String()
    
    @objc var webpageUrl = String()
    
    class func getData(success : @escaping (_ model : WPShareModel) -> ()) {
        WPDataTool.GETRequest(url: WPShareToAppURL, parameters: ["" : ""], success: { (result) in
            success(WPShareModel.mj_object(withKeyValues: result))
        }) { (error) in

        }
    }
    
}
