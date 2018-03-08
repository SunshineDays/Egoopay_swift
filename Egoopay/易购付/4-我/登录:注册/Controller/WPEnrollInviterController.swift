//
//  WPEnrollInviterController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPEnrollInviterController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "邀请的人"
        self.tableView.register(UINib.init(nibName: "WPEnrollInviterCell", bundle: nil), forCellReuseIdentifier: WPEnrollInviterCellID)
        self.tableView.separatorStyle = .none
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "跳过", style: .plain, target: self, action: #selector(self.skipAction))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  电话号码 */
    var phoneNumber = String()

    /**  密码 */
    var password = String()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEnrollInviterCell = tableView.dequeueReusableCell(withIdentifier: WPEnrollInviterCellID, for: indexPath) as! WPEnrollInviterCell
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        return cell
    }
 
    // MARK: - Action
    
    @objc func skipAction() {
        postEnrollData(tphone: "")
    }
    
    @objc func confirmAction() {
        let cell: WPEnrollInviterCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEnrollInviterCell
        if WPJudgeTool.validate(mobile: cell.phone_textField.text!) || cell.phone_textField.text?.count == 0 {
            postEnrollData(tphone: cell.phone_textField.text!)
        }
        else {
            WPProgressHUD.showInfor(status: "请输入正确的手机号")
        }
    }
    
    // MARK: - Request
    
    func postEnrollData(tphone: String) {
        let parameter = ["phone" : phoneNumber,
                         "ver" : WPUserInputAuthCode,
                         "password" : password,
                         "tphone" : tphone,
                         "mobileID" : WPAppInfor.iOSDeviceID(),
                         "deviceOem" : "iPhone",
                         "deviceOS" : "iOS" + WPAppInfor.iOSVersion(),
                         "appVersion" : WPAppInfor.appVersion()]
        WPProgressHUD.showProgressIsLoading()
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEnrollURL, parameters: parameter, success: { (result) in

            let model = WPRegisterModel.mj_object(withKeyValues: result)
            
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_clientID, value: model?.clientId)
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_phone, value: weakSelf?.phoneNumber)
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_payPasswordType, value: nil)
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_approvePassType, value: nil)
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_touchIDPay, value: nil)
            UserDefaults.standard.synchronize()
            
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
