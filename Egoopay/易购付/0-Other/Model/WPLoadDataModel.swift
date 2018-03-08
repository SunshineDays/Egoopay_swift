//
//  WPPostDataModel.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/11.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import Alamofire

class WPLoadDataModel: NSObject {
    
    /**  退出登录 */
    class func getData(success : @escaping (_ result : AnyObject) -> ()) {
        let vc = WPRegisterViewController()
        let navi = WPNavigationController.init(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = navi
        
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_clientID, value: nil)
        UserDefaults.standard.synchronize()
        
        //删除极光推送别名
        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
            if iResCode == 0 {
                NotificationCenter.default.removeObserver(self, name: .jpfNetworkDidLogin, object: nil)
            }
        }, seq: 1)
        WPDataTool.GETRequest(url: WPUserLogoutURL, parameters: nil, success: { (success) in
            
        }) { (error) in
            
        }
    }

    /**
     * 修改密码
     * passType: 1:登录密码  2:支付密码
     */
    class func postData(phone : Any, passType : Any, authCode : Any, newPassword : Any, success : @escaping (_ result : AnyObject) -> ()) {
        let parameter = ["phone" : phone, "passType" : (passType as! Bool) ? "1" : "2", "ver" : authCode, "newPassword" : WPPublicTool.base64EncodeString(string: newPassword as! String)]
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPChangePasswordURL, parameters: parameter, success: { (result) in
            success(result)
        }) { (error) in
            
        }
    }
    
    /**  设置支付密码 */
    class func postData(payPassword : Any, success : @escaping () -> ()) {
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPSetPayPasswordURL, parameters: ["payPassword" : WPPublicTool.base64EncodeString(string: payPassword as! String)], success: { (result) in
            success()
        }) { (error) in
            
        }
    }
    
    /**
     * 获取验证码
     * verType: 1:注册 2:修改密码 3:绑定银行卡
     */
    class func getData(phone : Any, verType : Any, success : @escaping () -> ()) {
        let parameter = ["phone" : phone, "verType" : verType]
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPAuthCodeURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "验证码发送成功")
            success()
        }) { (error) in
            
        }
    }
    
    /**  获取轮播图 */
    class func getData(bannerCode : Any, success : @escaping (_ dataArray : [Any]) -> ()) {
        WPDataTool.GETRequest(url: WPCycleScrollURL, parameters: ["bannerCode" : bannerCode], success: { (result) in
            success(result["home_banner"] as! [Any])
        }) { (error) in
            
        }
    }
    
    /**  判断银行卡类型 */
    class func postData(cardNumber : Any, success : @escaping (_ cardName : String, _ cardType : String) -> ()) {
        let urlString: String = "https://ccdcapi.alipay.com/validateAndCacheCardInfo.json"
        
        let parameter = ["_input_charset=utf-8&" : "utf-8", "cardNo" : cardNumber, "cardBinCheck" : "true"]
        WPProgressHUD.showProgressIsLoading()
        Alamofire.request(urlString, method: .post, parameters: parameter)
            .responseJSON { (response) in
            WPProgressHUD.dismiss()
            switch response.result {
                
            //数据解析成功
            case.success(let value):
                let result_dic = value as! NSDictionary
                let validated = result_dic["validated"] as AnyObject
                if validated.isEqual(1) || validated.isEqual("1") {
                    success(WPJudgeTool.validate(cardDic: result_dic), result_dic["cardType"] as? String == "DC" ? "2" : "1") //1:信用卡 2:储蓄卡
                }
                else {
                    WPProgressHUD.showInfor(status: "银行卡号有误")
                }
                
            //数据解析失败
            case.failure(let error):
                print(error)
            }
        }
    }
    
    /**  是否设置支付密码状态 */
    class func getIsSetPayPasswordData() {
        
        WPDataTool.GETRequest(url: WPUserJudgeInforURL, parameters: nil, success: { (result) in
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_payPasswordType, value: "YES")
        }) { (type) in

        }
        UserDefaults.standard.synchronize()
    }
    
    /**
     * 获取用户实名认证/商家认证状态
     * approveType: true:返回实名认证状态 false:返回商家认证状态
     *
     */
    class func getUserApproveStateData(approveType: Bool , approveResult: @escaping (_ isPass: Bool) -> ()) {
        WPUserInforModel.loadData(success: { (model) in
            
            if approveType { //实名认证
                // 1:已认证 2:认证失败 3:认证中 4:未认证
                switch model.iscertified {
                case 1:
                    approveResult(true)
                    WPUserDefaults.userDefaultsSave(key: WPUserDefaults_approvePassType, value: "YES") //实名认证成功
                case 2:
                    gotToUserApprove()
                case 3:
                    WPProgressHUD.showInfor(status: "实名信息审核中，请耐心等待")
                default:
                    gotToUserApprove()
                }
            }
            
            else { //商家认证
                
                // 实名认证: 1:已认证 2:认证失败 3:认证中 4:未认证
                switch model.iscertified { //要先判断是否通过实名认证
                case 1:
                    WPUserDefaults.userDefaultsSave(key: WPUserDefaults_approvePassType, value: "YES") //实名认证成功
                    // 商家认证: 1:已认证 2:认证失败 3:认证中 4:未认证
                    switch model.shopCertifyState {
                    case 1:
                        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_approveShopPassType, value: "YES") //商家认证成功
                        approveResult(true)
                    case 2:
                        gotToShopApprove()
                    case 3:
                        WPProgressHUD.showInfor(status: "商铺信息审核中，请耐心等待")
                    default:
                        gotToShopApprove()
                    }
                case 2:
                    gotToUserApprove()
                case 3:
                    WPProgressHUD.showInfor(status: "实名信息审核中，请耐心等待")
                default:
                    gotToUserApprove()
                }                
            }

            UserDefaults.standard.synchronize() //保存认证信息状态
            
        }) { (error) in
            
        }
    }
    
    
    class func gotToUserApprove() {
        WPInterfaceTool.alertController(title: "您还没有实名认证", confirmTitle: "去认证", confirm: { (alertAction) in
            WPInterfaceTool.rootViewController().pushViewController(WPUserApproveNumberController(), animated: true)
        }, cancel: { (alertAction) in
    
        })
    }
    
    class func gotToShopApprove() {
        WPInterfaceTool.alertController(title: "您还没有商家认证", confirmTitle: "去认证", confirm: { (alertAction) in
            WPInterfaceTool.rootViewController().pushViewController(WPShopApproveAController(), animated: true)
        }, cancel: { (alertAction) in
            
        })
    }

    
    class func postEShopAddToCart(model: WPEShopProductModel) {
        if model.option == 1 { //商品有属性
            WPProgressHUD.showProgressIsLoading()
            WPDataTool.GETRequest(url: WPEShopCertainSpecificationURL, parameters: ["id" : model.product_id], success: { (result) in
                WPProgressHUD.dismiss()
                let array = NSMutableArray()
                array.addObjects(from: WPEShopDetailSpecificationModel.mj_objectArray(withKeyValuesArray: result["options"]) as! [Any])
                let view = WPEShopShopDetailSelectView()
                view.imageUrl = model.image
                view.productID = model.product_id
                view.initInfor(array: array, model: nil, selectDic: nil)
                UIApplication.shared.keyWindow?.addSubview(view)
            }, failure: { (error) in
                
            })
        }
        else {
            let parameter = ["product_id" : model.product_id]
            WPProgressHUD.showProgressIsLoading()
            WPDataTool.POSTRequest(url: WPEShopCartAddURL, parameters: parameter, success: { (result) in
                WPProgressHUD.showSuccess(status: "添加到购物车成功")
            }) { (error) in
                
            }
        }
        
        
    }
    
}
