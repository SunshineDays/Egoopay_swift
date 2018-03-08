//
//  WPPasswordRegisterController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordRegisterController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "设置登录密码"
        
        self.tableView.register(UINib.init(nibName: "WPPasswordRegisterCell", bundle: nil), forCellReuseIdentifier: WPPasswordRegisterCellID)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.tableViewColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  电话号码 */
    var phoneNumber = String()

    /**  是否是注册界面 */
    var isEnroll = false
    
    
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
        let cell: WPPasswordRegisterCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordRegisterCellID, for: indexPath) as! WPPasswordRegisterCell
        cell.phone = phoneNumber
        if isEnroll {
            cell.confirm_button.setTitle("下一步", for: .normal)
            cell.confirm_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        }
        else {
            cell.confirm_button.addTarget(self, action: #selector(self.postChangePasswordData), for: .touchUpInside)
        }
        return cell
    }
    

    // MARK: - Action
    
    @objc func nextAction() {
        let vc = WPEnrollInviterController()
        let cell: WPPasswordRegisterCell = self.tableView.cellForRow(at: .init(row: 0, section: 0)) as! WPPasswordRegisterCell
        vc.phoneNumber = phoneNumber
        vc.password = cell.password_textField.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func postChangePasswordData() {
        let cell: WPPasswordRegisterCell = self.tableView.cellForRow(at: .init(row: 0, section: 0)) as! WPPasswordRegisterCell

        if (cell.password_textField.text?.count)! < 6 {
            WPProgressHUD.showInfor(status: "登录密码不能少于6位")
        }
        else {
            let parameter = ["phone" : phoneNumber,
                             "passType" : "1",
                             "ver" : WPUserInputAuthCode,
                             "newPassword" : WPPublicTool.base64EncodeString(string: cell.password_textField.text!)]
            WPProgressHUD.showProgressIsLoading()
            weak var weakSelf = self
            WPDataTool.POSTRequest(url: WPChangePasswordURL, parameters: parameter, success: { (result) in
                WPProgressHUD.showSuccess(status: "修改成功")
                WPInterfaceTool.popToViewController(navigationController: weakSelf?.navigationController, popCount: 3)
            }) { (error) in
                
            }
        }
    }

}
