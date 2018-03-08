//
//  WPPasswordPayController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordPayController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置支付密码"
        self.tableView.register(UINib.init(nibName: "WPPasswordPayCell", bundle: nil), forCellReuseIdentifier: WPPasswordPayCellID)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.tableViewColor()
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    /**  第一次设置支付密码 */
    var isSetPassword = false
    
    /**  隐藏下一步按钮 */
    var isHiddenButton = true
    
    /**  用户输入的密码 */
    var password = String()
    
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
        let cell: WPPasswordPayCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordPayCellID, for: indexPath) as! WPPasswordPayCell
        cell.isHiddenButton = isHiddenButton
        cell.password_textField.addTarget(self, action: #selector(self.textFieldChange(_:)), for: .editingChanged)
        cell.confirm_button.addTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
        return cell
    }
    
    // MARk: - Action
    
    @objc func textFieldChange(_ textField: UITextField) {
        if textField.text?.count == 6 && isHiddenButton {
            password = textField.text!
            let vc = WPPasswordPayController()
            vc.isSetPassword = isSetPassword
            vc.isHiddenButton = false
            vc.password = textField.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func confirmButtonAction() {
        let cell: WPPasswordPayCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPPasswordPayCell
        if password != cell.password_textField.text! {
            WPProgressHUD.showInfor(status: "两次密码输入不一致")
        }
        else {
            if isSetPassword {
                postSetPasswordData(password: password)
            }
            else {
                postChangePasswordData(password: password)
            }
        }
    }
    
    //设置支付密码
    func postSetPasswordData(password: String) {
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(baseUrl: WPBaseURL, url: WPSetPayPasswordURL, parameters: ["payPassword" : WPPublicTool.base64EncodeString(string: password)], success: { (result) in
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_payPasswordType, value: "YES")
            UserDefaults.standard.synchronize()
            WPProgressHUD.showSuccess(status: "设置成功")
            WPInterfaceTool.popToViewController(popCount: 2)
            WPInterfaceTool.alertController(title: "您的设备支持指纹识别，是否开通指纹支付", confirmTitle: "开通指纹支付", confirm: { (action) in
                WPKeyChainTool.keyChainSave(password, forKey: WPKeyChain_payPassword)
                WPUserDefaults.userDefaultsSave(key: WPUserDefaults_touchIDPay, value: "YES")
                UserDefaults.standard.synchronize()
                WPProgressHUD.showSuccess(status: "开通成功")
            }, cancel: { (action) in
                
            })
            
        }) { (error) in
            
        }
    }
    
    //修改支付密码
    func postChangePasswordData(password: String) {
        let parameter = ["phone" : WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!,
                         "passType" : "2",
                         "ver" : WPUserInputAuthCode,
                         "newPassword" : WPPublicTool.base64EncodeString(string: password)]
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPChangePasswordURL, parameters: parameter, success: { (result) in
            WPKeyChainTool.keyChainSave(password, forKey: WPKeyChain_payPassword)
            WPProgressHUD.showSuccess(status: "修改成功")
            WPInterfaceTool.popToViewController(popCount: 5)
        }) { (error) in
            
        }
    }

}
