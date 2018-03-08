//
//  WPEnrollPhoneController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/23.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPEnrollPhoneController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "注册"
        self.tableView.register(UINib.init(nibName: "WPEnrollPhoneCell", bundle: nil), forCellReuseIdentifier: WPEnrollPhoneCellID)
        self.tableView.separatorStyle = .none
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
        let cell: WPEnrollPhoneCell = tableView.dequeueReusableCell(withIdentifier: WPEnrollPhoneCellID, for: indexPath) as! WPEnrollPhoneCell
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        cell.protocol_button.addTarget(self, action: #selector(self.protocolAction), for: .touchUpInside)
        return cell
    }
    
    
    // MARK: - Action
    
    @objc func protocolAction() {
        let vc = WPWebViewController()
        vc.webUrl_string = WPUserProtocolWebURL
        vc.navigationItem.title = "用户使用协议"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextAction() {
        let cell: WPEnrollPhoneCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEnrollPhoneCell
        if WPJudgeTool.validate(mobile: cell.phone_textField.text!) {
            if cell.isAgree {
                weak var weakSelf = self
                WPLoadDataModel.getData(phone: cell.phone_textField.text!, verType: "1") {
                    let vc = WPPasswordAuthCodeController()
                    vc.authCodeType = 3
                    vc.phoneNumber = cell.phone_textField.text!
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                WPProgressHUD.showInfor(status: "请阅读并同意《用户使用协议》")
            }
        }
        else {
            WPProgressHUD.showInfor(status: "手机号码格式错误")
        }
        
        
    }
    

}
