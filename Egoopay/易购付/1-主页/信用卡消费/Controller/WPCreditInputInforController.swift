//
//  WPCreditInputInforController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/9.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPCreditInputInforController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "订单支付"
        self.tableView.register(UINib.init(nibName: "WPCreditInputInforCell", bundle: nil), forCellReuseIdentifier: WPCreditInputInforCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initInfor(password: String, money: String, creditModel: WPBankCardModel, depositModel: WPBankCardModel, channelModel: WPCreditChannelModel) {
        self.password = password
        self.money = money
        self.credit_model = creditModel
        self.deposit_model = depositModel
        self.channel_model = channelModel
    }

    var password = String()
    var money = String()
    var credit_model = WPBankCardModel()
    var deposit_model = WPBankCardModel()
    var channel_model = WPCreditChannelModel()
    
    
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
        let cell: WPCreditInputInforCell = tableView.dequeueReusableCell(withIdentifier: WPCreditInputInforCellID, for: indexPath) as! WPCreditInputInforCell
        cell.money_label.text = "￥" + money
        cell.creditModel = credit_model
        cell.depositModel = deposit_model
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        return cell
    }
    
    
    // MARK: - Action
    
    @objc func confirmAction() {
        let cell: WPCreditInputInforCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPCreditInputInforCell
        if (cell.cvv_textField.text?.count)! < 3 {
            WPProgressHUD.showInfor(status: "CVV为三位数字")
        }
        else if (cell.validity_textField.text?.count)! < 4 {
            WPProgressHUD.showInfor(status: "有效期格式错误")
        }
        else {
            let month = (cell.validity_textField.text! as NSString).substring(to: 2)
            let year = (cell.validity_textField.text! as NSString).substring(from: 2)
            
            postCreditRechargeData(password: password, money: money, cvv: cell.cvv_textField.text!, year: year, month: month)
        }
    }

    // MARK: - Request
               
    func postCreditRechargeData(password: String, money: String, cvv: String, year: String, month: String) {
        let parameter = ["clientId" : WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) ?? "",
                         "rechargeAmount" : money,
                         "receiveCardId" : deposit_model.id,
                         "payCardId" : credit_model.id,
                         "payPassword" : password,
                         "chanelId" : channel_model.id,
                         "year" : WPPublicTool.base64EncodeString(string: year),
                         "month" : WPPublicTool.base64EncodeString(string: month),
                         "cvv" : WPPublicTool.base64EncodeString(string: cvv)] as [String : Any]
        WPProgressHUD.showProgress(status: WPAppName)
                weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPCreditRechargeURL, parameters: parameter, success: { (result) in
            weakSelf?.navigationController?.popToRootViewController(animated: true)
        }) { (error) in

        }
    }

}
