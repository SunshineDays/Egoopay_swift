//
//  WPJpushSeriveTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPJpushSeriveTool: NSObject {

    /**  极光推送跳转界面 */
    class func jpushService(userInfor: NSDictionary) {
        if userInfor["bis_result"] != nil {
            let result: NSDictionary = userInfor["bis_result"] as! NSDictionary
            
            let target: String = (result["target"] as? String)!
            
            switch target {
            case "trade_detail", "qr_bill":
                showBillDetail(userInfor: userInfor)
            case "sys_notice":
                showMessageDetail(userInfor: userInfor)
            case "authenticate":
                showUserApproveDetail(userInfor: userInfor)
            case "mer_cert":
                showShopApproveDetail(userInfor: userInfor)
            default:
                break
            }
        }
        
    }
    
    /**  账单详情 */
    class func showBillDetail(userInfor: NSDictionary) {
        let vc = WPBillDetailController()
        let bis_result: NSDictionary = userInfor["bis_result"] as! NSDictionary
        vc.orderNo = bis_result["orderNo"] as! String
        WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        
    }
    
    /**  消息详情 */
    class func showMessageDetail(userInfor: NSDictionary) {
        let model: WPMessageSystemModel = WPMessageSystemModel.mj_object(withKeyValues: resultDictionary(userInfor: userInfor, key: "content"))
        let vc = WPMessageDetailController()
        vc.message_model = model
        WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
    }
    
    /**  实名认证 */
    class func showUserApproveDetail(userInfor: NSDictionary) {
        let idCardDic = resultDictionary(userInfor: userInfor, key: "IdCard")
        if idCardDic["auditStatus"] as! Int == 1 {
            WPInterfaceTool.rootViewController().pushViewController(WPUserInforController(), animated: true)
        }
        else {
            WPInterfaceTool.rootViewController().pushViewController(WPUserApproveNumberController(), animated: true)
        }
    }
    
    /**  商家认证 */
    class func showShopApproveDetail(userInfor: NSDictionary) {
        let shopDic = resultDictionary(userInfor: userInfor, key: "shop")
        if shopDic["auditStatus"] as! Int == 1 {
            WPInterfaceTool.rootViewController().pushViewController(WPUserInforController(), animated: true)
        }
        else {
            WPInterfaceTool.rootViewController().pushViewController(WPShopApproveAController(), animated: true)
        }
    }

    /**  把推送得到的字符串转换成字典 */
    class func resultDictionary(userInfor: NSDictionary, key: String) -> NSDictionary {
        let result: NSDictionary = userInfor["bis_result"] as! NSDictionary
        
        let json_string: String = result[key] as! String
        let json_data: Data = json_string.data(using: String.Encoding.utf8)!
        
        let result_dic = try? JSONSerialization.jsonObject(with: json_data, options: .mutableContainers)
        
        return result_dic as! NSDictionary
    }
    
}
