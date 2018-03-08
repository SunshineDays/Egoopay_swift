//
//  WPInforTypeTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPInforTypeTool: NSObject {
    
    /**  账单图片 */
    class func billImage(model: WPBillInforListModel) -> UIImage {
        let array = [#imageLiteral(resourceName: "icon_chongzhi"), #imageLiteral(resourceName: "icon_chongzhi"), #imageLiteral(resourceName: "icon_zhuanzhang"), #imageLiteral(resourceName: "icon_guojichongzhi"), #imageLiteral(resourceName: "icon_tixian"), #imageLiteral(resourceName: "icon_xiaofei"), #imageLiteral(resourceName: "icon_shoukuan"), #imageLiteral(resourceName: "icon_xiaofei"), #imageLiteral(resourceName: "icon_fenruntixian"), #imageLiteral(resourceName: "icon_shanghushengji"), #imageLiteral(resourceName: "icon_dailishengji"), #imageLiteral(resourceName: "icon_huafei"), #imageLiteral(resourceName: "icon_liuliang"), #imageLiteral(resourceName: "icon_bill_shop")]
        if model.tradeType >= array.count {
            return #imageLiteral(resourceName: "icon_chongzhi")
        }
        else {
            return array[model.tradeType]
        }
    }
    
    /**  账单进出金额 */
    class func billSymbol(model: WPBillInforListModel) -> String {
        return (model.inPaystate == 0 ? "" : (model.inPaystate == 1 ? "+ " : "- ")) + String(format: "%.2f", model.amount)
    }

    /**  账单状态字体颜色 */
    class func billColor(model: WPBillInforListModel) -> UIColor {
        var color = String()
        switch model.tradeTypeName {
        case "失败", "异常单":
            color = "EE3B3B"
        case "成功":
            color = "ffffff"
        case "已取消":
            color = "909090"
        case "待支付", "待确认", "待返回":
            color = "50bca3"
        default:
            color = "000000"
        }
        return UIColor.colorConvert(colorString: color)
    }

    /**  支付方式 */
    class func billType(wayModel: WPBillInforModel) -> String {
        let way_array = ["", "银行卡", "微信", "支付宝", "余额", "国际信用卡", "QQ钱包", "京东钱包", "", "", ""];
        return way_array[wayModel.payMethod]
    }
    
    /**  会员等级 */
    class func userVip(merchantlvID: NSInteger) -> String {
        let array = [" ", "白银会员", "黄金会员", "铂金会员", "钻石会员"]
        return array[merchantlvID]
    }
    
    class func userVipImage(merchantlvID: NSInteger) -> UIImage {
        let array = [#imageLiteral(resourceName: "icon_vip_baiyin"), #imageLiteral(resourceName: "icon_vip_baiyin"), #imageLiteral(resourceName: "icon_vip_huangjin"), #imageLiteral(resourceName: "icon_vip_baijin"), #imageLiteral(resourceName: "icon_vip_zuanshi")]
        return array[merchantlvID]
    }
    
    /**  代理等级 */
    class func userVip(agentGradeID: NSInteger) -> String {
        let array = ["普通商家", "银牌加盟商", "金牌加盟商", "钻石加盟商", "黑钻加盟商"]
        return array[agentGradeID]
    }
    
    class func userVipImage(agentGradeID: NSInteger) -> UIImage {
        let array = [#imageLiteral(resourceName: "icon_defaultAvater"), #imageLiteral(resourceName: "icon_yin_daili"), #imageLiteral(resourceName: "icon_jin_daili"), #imageLiteral(resourceName: "icon_zuanshi_daili"), #imageLiteral(resourceName: "icon_heizuan_daili")]
        return array[agentGradeID]
    }
    
    /**  银行卡图标 */
    class func bankImage(model: WPBankCardModel) -> UIImage {
        let code_string: String = "BANK_" + model.bankCode
        var result_iamge = UIImage.init(named: code_string)
        if result_iamge == nil {
            result_iamge = model.cardType == 1 ? #imageLiteral(resourceName: "icon_defaultCredit") : #imageLiteral(resourceName: "icon_defaultDeposit")
        }
        return result_iamge as UIImage!
    }
    
    /**  根据app名称判断app图标 */
    class func appImage(appName: String) -> UIImage {
        let appInfor_dic = ["微信支付" : #imageLiteral(resourceName: "icon_payWithWeChat"), "支付宝支付" : #imageLiteral(resourceName: "icon_payWithApliy"), "QQ钱包支付" : #imageLiteral(resourceName: "icon_payWithQQ")]
        return appInfor_dic[appName]!
    }
    
    /**  根据app名称判断app ID */
    class func appID(appName: String) -> String {
        let appInfor_dic = ["微信支付" : "2", "支付宝支付" : "3", "QQ钱包支付" : "6", "余额支付" : "4"]
        return appInfor_dic[appName]!
    }

}
