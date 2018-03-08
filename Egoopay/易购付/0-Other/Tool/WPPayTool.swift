//
//  WPPayTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import LocalAuthentication

class WPPayTool: NSObject {

    /**  输入支付密码 */
    class func pay(password : @escaping (_ password : String) -> ()) {
        WPLoadDataModel.getUserApproveStateData(approveType: true) { (isPass) in
            
            //设置了支付密码
            if WPJudgeTool.isSetPayPassword() {
                let context = LAContext()
                var error: NSError? = nil
                
                //判断设备支持状态和用户是否开通指纹支付
                let isTouchID = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) && WPJudgeTool.isOpenTouchIDPay()
                
                //支持指纹验证且用户开通
                if isTouchID {
                    context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请验证已有指纹，用于支付", reply: { (success, error) in
                        if success {
                            OperationQueue.main.addOperation({
                                password(WPKeyChainTool.keyChainReadforKey(WPKeyChain_payPassword))
                            })
                        }
                        else {
                            switch (error as! LAError).code {
                            //用户取消验证Touch ID
                            case LAError.userCancel: break
                                
                            default:
                                OperationQueue.main.addOperation({
                                    let view = WPPayPasswordView()
                                    
                                    //输入完密码
                                    view.inputPassword = {(pass) -> Void in
                                        password(WPPublicTool.base64EncodeString(string: pass))
                                    }
                                    //忘记密码
                                    view.forgetPassword = {(forgetPassword) -> Void in
                                        WPInterfaceTool.rootViewController().pushViewController(WPPasswordHintController(), animated: true)
                                    }
                                    UIApplication.shared.keyWindow?.addSubview(view)
                                })
                            }
                        }
                    })
                }
                //不支持指纹验证/用户没有开通
                else {
                    OperationQueue.main.addOperation({
                        let view = WPPayPasswordView()
                        
                        //输入完密码
                        view.inputPassword = {(pass) -> Void in
                            password(WPPublicTool.base64EncodeString(string: pass))
                        }
                        //忘记密码
                        view.forgetPassword = {(forgetPassword) -> Void in
                            WPInterfaceTool.rootViewController().pushViewController(WPPasswordHintController(), animated: true)
                        }
                        
                        UIApplication.shared.keyWindow?.addSubview(view)
                    })
                }
            }
            else {
                goToSetPayPassword()
            }
        }
        
    }
    
    class func payView(password : @escaping (_ password : String) -> ()) {
        WPLoadDataModel.getUserApproveStateData(approveType: true) { (isPass) in
            if WPJudgeTool.isSetPayPassword() {
                let view = WPPayPasswordView()
                
                view.inputPassword = {(pass) -> Void in
                    password(WPPublicTool.base64EncodeString(string: pass))
                }
                view.forgetPassword = {(forgetPassword) -> Void in
                    WPInterfaceTool.rootViewController().pushViewController(WPPasswordHintController(), animated: true)
                }
                UIApplication.shared.keyWindow?.addSubview(view)
            }
            else {
                goToSetPayPassword()
            }
        }
    }
    
    /**  验证TouchID */
    class func touchID(success : @escaping (_ success : Any) -> (), failure : @escaping (_ error : Any) -> ()) {
        let context = LAContext()
        var error: NSError? = nil
        
        //判断设备支持状态和用户是否开通指纹支付
        let isTouchID = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        //支持指纹验证
        if isTouchID {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请验证已有指纹", reply: { (success, error) in
                if success {
                    OperationQueue.main.addOperation({
                        print("success1")
                    })
                }
                else {
                    switch (error as! LAError).code {
                    //用户取消验证Touch ID
                    case LAError.userCancel: break
                    default:
                        OperationQueue.main.addOperation({
                            failure(error!)
                        })
                    }
                }
            })
        }
        //不支持指纹验证
        else {
            OperationQueue.main.addOperation({
                failure(error!)
            })
        }
    }
    
    /**  支付订单信息弹窗 */
    class func payOrderView(tradeType : NSInteger, productId : NSInteger, phone : String) {
        //判断是否实名认证
        WPLoadDataModel.getUserApproveStateData(approveType: true) { (isPass) in
            if WPJudgeTool.isSetPayPassword() {
                let parameter = ["tradeType" : tradeType,
                                 "productId" : productId,
                                 "phone" : phone] as [String : Any]
                WPProgressHUD.showProgress(status: WPAppName)
                WPDataTool.POSTRequest(url: WPMakeOrderURL, parameters: parameter, success: { (result) in
                    UIApplication.shared.keyWindow?.endEditing(true)
                    let view = WPPayInforView()
                    view.initInfor(result: result as! NSDictionary)
                    UIApplication.shared.keyWindow?.addSubview(view)
                    
                }) { (error) in
                    
                }
            }
            else {
                goToSetPayPassword()
            }
        }
    }
    
    class func goToSetPayPassword() {
        WPInterfaceTool.alertController(title: "您还没有设置支付密码", confirmTitle: "去设置", confirm: { (alertAction) in
            let vc = WPPasswordPayController()
            vc.isSetPassword = true
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        }, cancel: { (alertAction) in
            
        })
    }
    
    
}
