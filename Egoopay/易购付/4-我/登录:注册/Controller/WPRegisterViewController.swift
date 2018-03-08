//
//  WPRegisterViewController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPRegisterViewController: WPBaseTableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "登录"

        self.tableView.register(UINib.init(nibName: "WPRegisterViewCell", bundle: nil), forCellReuseIdentifier: WPRegisterViewCellID)
        self.tableView.separatorStyle = .none
        self.tableView.addSubview(WPThemeColorView())
        if WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) != nil {
            getUserAvaterData(phone: WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        let cell: WPRegisterViewCell = tableView.dequeueReusableCell(withIdentifier: WPRegisterViewCellID, for: indexPath) as! WPRegisterViewCell
        cell.account_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        cell.forget_button.addTarget(self, action: #selector(self.forgetPasswordAction), for: .touchUpInside)
        cell.enroll_button.addTarget(self, action: #selector(self.enrollAction), for: .touchUpInside)
        return cell
    }
 
    
    
    
    
    // MARK: - Action
    
    @objc func textFieldAction(_ textField: UITextField) {
        if WPJudgeTool.validate(mobile: textField.text!) {
            getUserAvaterData(phone: textField.text!)
        }
    }
    
    @objc func confirmAction() {
        let cell: WPRegisterViewCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPRegisterViewCell
        if !WPJudgeTool.validate(mobile: cell.account_textField.text!) {
            WPProgressHUD.showInfor(status: "手机号码格式错误")
        }
        else {
            postRegisterData(phone: cell.account_textField.text!, password: cell.password_textField.text!)
        }
    }

    @objc func forgetPasswordAction() {
        self.navigationController?.pushViewController(WPPasswordPhoneController(), animated: true)
    }
    
    @objc func enrollAction() {
        self.navigationController?.pushViewController(WPEnrollPhoneController(), animated: true)
    }
    
    
    // MARK: - Request
    
    func getUserAvaterData(phone: String) {
        let cell: WPRegisterViewCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPRegisterViewCell
        WPDataTool.GETRequest(url: WPUserAvaterWithPhoneURL, parameters: ["phone" : phone], success: { (result) in
            cell.avater_imageView.sd_setImage(with: URL.init(string: result["picurl"] as! String), placeholderImage: #imageLiteral(resourceName: "icon"))
        }) { (error) in
            cell.avater_imageView.image = #imageLiteral(resourceName: "icon")
        }
    }
    
    
    func postRegisterData(phone: String, password: String) {
        let parameter = ["phone" : phone,
                         "password" : WPPublicTool.base64EncodeString(string: password),
                         "mobileID" : WPAppInfor.iOSDeviceID(),
                         "deviceOem" : "iPhone",
                         "deviceOS" : "iOS" + WPAppInfor.iOSVersion(),
                         "appVersion" : WPAppInfor.appVersion()]
        
        weak var weakSelf = self
        
        WPDataTool.POSTRequest(url: WPRegisterURL, parameters: parameter, success: { (result) in
            
            let model = WPRegisterModel.mj_object(withKeyValues: result)
            
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_clientID, value: model?.clientId)
            //如果不是上一个账户，清除数据
            if phone != WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) {
                WPUserDefaults.userDefaultsSave(key: WPUserDefaults_phone, value: phone)
                WPUserDefaults.userDefaultsSave(key: WPUserDefaults_payPasswordType, value: nil)
                WPUserDefaults.userDefaultsSave(key: WPUserDefaults_approvePassType, value: nil)
                WPUserDefaults.userDefaultsSave(key: WPUserDefaults_touchIDPay, value: nil)
            }
            UserDefaults.standard.synchronize()
            
            //注册极光推送
            JPUSHService.setAlias(model?.mer_id, completion: { (iResCode, iAlias, seq) in
                if iResCode == 0 {
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
                }
            }, seq: 1)
            
            let animation = CATransition()
            animation.duration = 0.2
            animation.type = kCATransitionFade
            UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
            UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
            
            weakSelf?.getUserApproveResultData()
            
        }) { (error) in
            
        }
    }
    
    func getUserApproveResultData() {
        WPUserInforModel.loadData(success: { (model) in
            if !(model.iscertified == 1 || model.iscertified == 3) {
                let view = WPRemindUserToApproveView()
                UIApplication.shared.keyWindow?.addSubview(view)
            }
        }) { (error) in
            
        }
    }

}
