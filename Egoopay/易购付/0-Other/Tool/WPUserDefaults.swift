//
//  WPUserDefaults.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

/**  记录用户是否是第一次安装 */
let WPUserDefault_firstInstall = "WPUserDefault_firstInstall"

/**  ClientID */
let WPUserDefaults_clientID = "WPUserDefaults_clientID"

/**  手机号码 */
let WPUserDefaults_phone = "WPUserDefaults_phone"

/**  是否通过实名认证 */
let WPUserDefaults_approvePassType = "WPUserDefaults_approvePassType"

/**  是否通过商家认证 */
let WPUserDefaults_approveShopPassType = "WPUserDefaults_approveShopPassType"

/**  是否设置支付密码 */
let WPUserDefaults_payPasswordType = "WPUserDefaults_payPasswordType"

/**  指纹登录 */
let WPUserDefaults_touchIDRegister = "WPUserDefaults_touchIDRegister"

/**  指纹支付 */
let WPUserDefaults_touchIDPay = "WPUserDefaults_touchIDPay"

/**  是否是 显示商城 */
let WPUserDefaults_isEShop = "WPUserDefaults_isEShop"

/**  搜索历史记录 */
let WPUserDefaults_searchHistory = "WPUserDefaults_searchHistory"

class WPUserDefaults: NSObject {
    
    // MARK: - 保存
    class func userDefaultsSave(key: String, value: String?) -> Void {
        return UserDefaults.standard.setValue(value, forKey: key)
    }
    
    
    // MARK: - 读取
    class func userDefaultsRead(key: String) -> String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    // MARK: - 保存(数组)
    class func userDefaultsSave(key: String, value: Array<Any>) -> Void {
        return UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - 读取(数组)
    class func userDefaultsRead(key: String) -> Array<Any> {
        return (UserDefaults.standard.object(forKey: key) as? Array) ?? []
    }
    
    
}
