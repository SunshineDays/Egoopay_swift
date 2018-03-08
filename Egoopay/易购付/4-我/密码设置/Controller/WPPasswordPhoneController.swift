//
//  WPPasswordPhoneController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordPhoneController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "找回密码"
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "WPPasswordPhoneCell", bundle: nil), forCellReuseIdentifier: WPPasswordPhoneCellID)
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
        let cell: WPPasswordPhoneCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordPhoneCellID, for: indexPath) as! WPPasswordPhoneCell
        cell.next_button.addTarget(self, action: #selector(self.getAuthCodeData), for: .touchUpInside)
        return cell
    }

    
    // MARK: - Request
    
    @objc func getAuthCodeData() {
        let cell: WPPasswordPhoneCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPPasswordPhoneCell
        if !WPJudgeTool.validate(mobile: cell.phone_textField.text!) {
            WPProgressHUD.showInfor(status: "手机号码格式错误")
        }
        else {
            weak var weakSelf = self
            //判断是否注册
            WPProgressHUD.showProgressIsLoading()
            WPDataTool.POSTRequest(url: WPJudgePhoneURL, parameters: ["phone" : cell.phone_textField.text!], success: { (result) in
                let parameter = ["phone" : cell.phone_textField.text!, "verType" : "2"]
                //获取验证码
                WPProgressHUD.showProgressIsLoading()
                WPDataTool.POSTRequest(url: WPAuthCodeURL, parameters: parameter, success: { (result) in
                    let vc = WPPasswordAuthCodeController()
                    vc.phoneNumber = cell.phone_textField.text!
                    vc.authCodeType = 1
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }) { (error) in
                    
                }
            }, failure: { (error) in
                
            })
        }
    }

}
