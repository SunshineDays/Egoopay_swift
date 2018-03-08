//
//  WPDataTool.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import Alamofire

class WPDataTool: NSObject, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    /** GET请求
     * superview: self.view
     * view: self.noResultView
     */
    class func GETRequest(url: String, parameters: [String : Any]?, superview: UIView, view: WPNoResultView, success: @escaping (_ response : NSDictionary)->(), networkError: @escaping (_ button : UIButton)->(), failure: @escaping (_ error : Any)->()) {
        let urlString: String = (WPJudgeTool.isEShop() ? WPBaseEShopURL : WPBaseURL) + url
        OperationQueue.main.addOperation {
            Alamofire.request(urlString, method: .get, parameters: self.joinParameters(parameters: parameters ?? ["" : ""]))
                .responseJSON { (response) in
                    switch response.result {
                    //数据解析成功
                    case.success(let value):
                        view.hiddenNoResultView()
                        let type = (value as! NSDictionary)["type"] as AnyObject
                        let result: NSDictionary = (value as! NSDictionary)["result"] as! NSDictionary
                        
                        if type.isEqual("1") || type.isEqual(1) {
                            success(result)
                        }
                        else {
                            showResult(type: type, result: result)
                            failure("")
                        }
                    //数据解析失败
                    case.failure( _):
                        //解析失败可能是转义字符导致的，判断是否获得数据
                        if (response.data?.count)! > 0 {
                            view.hiddenNoResultView()
                            //获取去掉转义字符的字典
                            let dataDictionary: NSDictionary = replaceEsacpeCharacter(data: response.data!)
                            if dataDictionary != ["" : ""] {
                                let type = dataDictionary["type"] as AnyObject
                                let result: NSDictionary = dataDictionary["result"] as! NSDictionary
                                if type.isEqual("1") || type.isEqual(1) {
                                    success(result)
                                }
                                else {
                                    showResult(type: type, result: result)
                                }
                            }
                            else {
                                UIApplication.shared.keyWindow?.endEditing(true)
                                view.showResultView(view: superview, loadAgain: { (button) in
                                    networkError(button)
                                })
                            }
                        }
                        else {
                            UIApplication.shared.keyWindow?.endEditing(true)
                            view.showResultView(view: superview, loadAgain: { (button) in
                                networkError(button)
                            })
                        }
                    }
            }
        }
    }

    
    /**  GET请求 */
    class func GETRequest(url: String, parameters: [String : Any]?, success: @escaping (_ response : NSDictionary)->(), failure: @escaping (_ error : Any)->()) {
        var urlString: String = (WPJudgeTool.isEShop() ? WPBaseEShopURL : WPBaseURL) + url
        if url == WPUserInforURL {
            urlString = WPBaseURL + url
        }
        OperationQueue.main.addOperation {
            Alamofire.request(urlString, method: .get, parameters: self.joinParameters(parameters: parameters ?? ["" : ""]))
                .responseJSON { (response) in
                switch response.result {
                //数据解析成功
                case.success(let value):
                    let type = (value as! NSDictionary)["type"] as AnyObject
                    let result: NSDictionary = (value as! NSDictionary)["result"] as! NSDictionary
                    
                    if type.isEqual("1") || type.isEqual(1) {
                        success(result)
                    }
                    else {
                        showResult(type: type, result: result)
                        failure(type)
                    }
                //数据解析失败
                case.failure(let error):
                    //解析失败可能是转义字符导致的，判断是否获得数据
                    if (response.data?.count)! > 0 {
                        //获取去掉转义字符的字典
                        let dataDictionary: NSDictionary = replaceEsacpeCharacter(data: response.data!)
                        if dataDictionary != ["" : ""] {
                            let type = dataDictionary["type"] as AnyObject
                            let result: NSDictionary = dataDictionary["result"] as! NSDictionary
                            if type.isEqual("1") || type.isEqual(1) {
                                success(result)
                            }
                            else {
                                showResult(type: type, result: result)
                                failure(type)
                            }
                        }
                        else {
                            failure(error)
                        }
                    }
                    else {
                        failure(error)
                        WPProgressHUD.showError(status: "网络错误")
                    }
                }
            }
        }
    }
    
    
    /**  POST请求 */
    class func POSTRequest(url: String, parameters: [String : Any]?, success: @escaping (_ response : AnyObject)->(), failure: @escaping (_ error : Any)->()) {
        let urlString: String = (WPJudgeTool.isEShop() ? WPBaseEShopURL : WPBaseURL) + url
//        WPProgressHUD.showProgressIsLoading()
        OperationQueue.main.addOperation {
            Alamofire.request(urlString, method: .post, parameters: self.joinParameters(parameters: parameters ?? ["" : ""]) )
                .responseJSON { (response) in
                WPProgressHUD.dismiss()
                switch response.result {
                //数据解析成功
                case.success(let value):
                    let type = (value as! NSDictionary)["type"] as AnyObject
                    let result: NSDictionary = (value as! NSDictionary)["result"] as! NSDictionary
                    
                    if type.isEqual("1") || type.isEqual(1) {
                        success(result)
                    }
                    else {
                        showResult(type: type, result: result)
                        failure(type)
                    }
                //数据解析失败
                case.failure(let error):
                    //解析失败可能是转义字符导致的，判断是否获得数据
                    if (response.data?.count)! > 0 {
                        //获取去掉转义字符的字典
                        let dataDictionary: NSDictionary = replaceEsacpeCharacter(data: response.data!)
                        if dataDictionary != ["" : ""] {
                            let type = dataDictionary["type"] as AnyObject
                            let result: NSDictionary = dataDictionary["result"] as! NSDictionary
                            if type.isEqual("1") || type.isEqual(1) {
                                success(result)
                            }
                            else {
                                showResult(type: type, result: result)
                                failure(type)
                            }
                        }
                        else {
                            failure(error)
                        }
                    }
                    else {
                        failure(error)
                        WPProgressHUD.showError(status: "网络错误")
                    }
                }
            }
        }
    }
    
    
    
    /**  POST请求 */
    class func POSTRequest(baseUrl: String, url: String, parameters: [String : Any]?, success: @escaping (_ response : AnyObject)->(), failure: @escaping (_ error : Any)->()) {
        let urlString: String = baseUrl + url
        //        WPProgressHUD.showProgressIsLoading()
        OperationQueue.main.addOperation {
            Alamofire.request(urlString, method: .post, parameters: self.joinParameters(parameters: parameters ?? ["" : ""]) )
                .responseJSON { (response) in
                    WPProgressHUD.dismiss()
                    switch response.result {
                    //数据解析成功
                    case.success(let value):
                        let type = (value as! NSDictionary)["type"] as AnyObject
                        let result: NSDictionary = (value as! NSDictionary)["result"] as! NSDictionary
                        
                        if type.isEqual("1") || type.isEqual(1) {
                            success(result)
                        }
                        else {
                            showResult(type: type, result: result)
                            failure(type)
                        }
                    //数据解析失败
                    case.failure(let error):
                        //解析失败可能是转义字符导致的，判断是否获得数据
                        if (response.data?.count)! > 0 {
                            //获取去掉转义字符的字典
                            let dataDictionary: NSDictionary = replaceEsacpeCharacter(data: response.data!)
                            if dataDictionary != ["" : ""] {
                                let type = dataDictionary["type"] as AnyObject
                                let result: NSDictionary = dataDictionary["result"] as! NSDictionary
                                if type.isEqual("1") || type.isEqual(1) {
                                    success(result)
                                }
                                else {
                                    showResult(type: type, result: result)
                                    failure(type)
                                }
                            }
                            else {
                                failure(error)
                            }
                        }
                        else {
                            failure(error)
                            WPProgressHUD.showError(status: "网络错误")
                        }
                    }
            }
        }
    }
    
    
    /**  拼接参数 */
    class func joinParameters(parameters: [String : Any]) -> [String : Any] {
        let parameter: NSMutableDictionary = ["clientId" : WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) ?? ""]
        parameter.addEntries(from: parameters)
        
        return parameter as! [String : Any]
    }
    
    
    /**  去掉转义字符 */
    class func replaceEsacpeCharacter(data: Data) -> (NSDictionary) {
        // Data -> String
        var dataString: String = String.init(data: data, encoding: String.Encoding.utf8)!
        dataString = dataString.replacingOccurrences(of: "\n", with: "\\n")
        
        // String -> Data -> NSDictionary
        let data: Data = dataString.data(using: String.Encoding.utf8)!
        let resultData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        
        if resultData != nil {
            return (resultData as? NSDictionary)!
        }
        else { //服务器返回异常数据
            WPProgressHUD.showError(status: "网络错误")

            return ["" : ""]
        }
    }
    
    
    /**  显示请求状态 */
    class func showResult(type: AnyObject, result: NSDictionary) {
        if type.isEqual("-1") || type.isEqual(-1) {
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_clientID, value: nil)
            WPInterfaceTool.alertController(title: "您已下线，请重新登录", confirmTitle: "重新登录", confirm: { (alertAction) in
                WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: nil)
                WPLoadDataModel.getData(success: { (success) in
                    
                })
            }, cancel: { (error) in
                
            })
        }
        else if result["err_msg"] != nil {
            WPProgressHUD.showInfor(status: result["err_msg"] as! String)
        }
//        else {
//            WPProgressHUD.showError(status: "网络错误")
//        }
        UserDefaults.standard.synchronize()
    }

    /**  上/下拉 刷新数据 */
    class func endRefresh(tableView: UITableView?, array: NSArray?) -> () {
        if tableView != nil {
            if (tableView?.mj_header != nil) {
                tableView?.mj_header.endRefreshing()
            }
            tableView?.reloadData()
            
            if (array?.count)! < 20 {
                if (tableView?.mj_footer != nil) {
                    tableView?.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            else {
                if (tableView?.mj_footer != nil) {
                    tableView?.mj_footer.endRefreshing()
                }
            }
        }
    }
    
}
