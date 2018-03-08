//
//  WPPasswordAuthCodeController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordAuthCodeController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "填写验证码"
        self.tableView.register(UINib.init(nibName: "WPPasswordAuthCodeCell", bundle: nil), forCellReuseIdentifier: WPPasswordAuthCodeCellID)
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  通道B的数据模型 */
    var channel_dic = NSDictionary()
    
    /**  通道B发送验证码得到的数据 */
    var channel_model = WPCreditChannelBModel()
    
    /**  填写的银行卡信息 */
    var cardInfor_dic = NSMutableDictionary()
    
    /**  电话号码 */
    var phoneNumber = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) ?? ""
    
    /**  0:绑定银行卡 1:修改登录密码 2:修改支付密码 3:注册 4:信用卡通道B获取验证码 */
    var authCodeType = 0
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPPasswordAuthCodeCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordAuthCodeCellID, for: indexPath) as! WPPasswordAuthCodeCell
        cell.phone = phoneNumber
        cell.again_button.addTarget(self, action: #selector(self.getAuthCodeData), for: .touchUpInside)
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return cell
    }
 
    
    // MAARK: - Action

    @objc func getAuthCodeData() {
        //verType: 1:注册 2:修改密码 3:绑定银行卡
        var verType = String()
        if authCodeType != 4 {
            switch authCodeType {
            case 0:
                phoneNumber = cardInfor_dic["phone"] as! String
                verType = "3"
            case 1, 2:
                verType = "2"
            case 3:
                verType = "1"
            default:
                break
            }
            WPLoadDataModel.getData(phone: phoneNumber, verType: verType) {
                
            }
        }
        else {
            switch authCodeType {
            case 4:
                postCreditRechargeBAuthCodeData()
            default:
                break
            }
        }
    }
    
    @objc func nextAction() {
        let cell: WPPasswordAuthCodeCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPPasswordAuthCodeCell
        if cell.authCode_textField.text?.count == 6 {
            if authCodeType != 4 {
                weak var weakSelf = self
                // 检查验证码是否正确
                WPDataTool.POSTRequest(url: WPChcekPhoneCodeURL, parameters: ["phone" : phoneNumber, "ver" : cell.authCode_textField.text!], success: { (result) in
                    //把验证码保存方便之后调用
                    WPUserInputAuthCode = cell.authCode_textField.text!
                    switch weakSelf?.authCodeType {
                    case 0?: //绑定银行卡
                        weakSelf?.postCardInforData()
                    case 1?, 3?: //修改登录密码、注册
                        let vc = WPPasswordRegisterController()
                        vc.phoneNumber = (weakSelf?.phoneNumber)!
                        vc.isEnroll = weakSelf?.authCodeType == 3
                        weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    case 2?: //修改支付密码
                        weakSelf?.navigationController?.pushViewController(WPPasswordIDApproveController(), animated: true)
                    default:
                        break
                    }
                }) { (error) in
                    
                }
            }
            else {
                postCreditRechargeBInforData(code: cell.authCode_textField.text!)
            }
        }
        else {
            WPProgressHUD.showInfor(status: "验证码错误")
        }
        
        
    }
    
    //绑定银行卡
    func postCardInforData() {
        self.cardInfor_dic.setObject(WPUserInputAuthCode, forKey: "ver" as NSCopying)
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPUserAddCardURL, parameters: self.cardInfor_dic as? [String : Any], success: { (success) in
            WPProgressHUD.showSuccess(status: "添加成功")
            WPInterfaceTool.popToViewController(popCount: 3)
        }) { (error) in
            
        }
    }

    
    /**  信用卡通道B获取验证码 */
    func postCreditRechargeBAuthCodeData() {
        WPProgressHUD.showProgress(status: WPAppName)
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPCreditRechargeBURL, parameters: channel_dic as? [String : Any], success: { (result) in
            WPProgressHUD.showSuccess(status: "验证码发送成功")
            weakSelf?.channel_model = WPCreditChannelBModel.mj_object(withKeyValues: result)
        }) { (error) in
            
        }
    }
    
    /**  信用卡通道B信用卡取现 */
    func postCreditRechargeBInforData(code: String) {
        let parameter = ["orderNo" : channel_model.orderNo,
                         "wlbMerNo" : channel_model.wlbMerNo,
                         "msgCode" : code]
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPCreditRechargeBInforURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "交易成功")
            WPInterfaceTool.popToViewController(popCount: 2)
        }) { (error) in
            
        }
    }
    
}
