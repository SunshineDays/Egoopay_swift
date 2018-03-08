//
//  WPCreditRechargeController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/7.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit
import Alamofire

class WPCreditRechargeController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "信用卡取现"
        getCreditCardData()
        getDepositCardData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  取现金额 */
    var money = String()
    
    /**  选择的通道的模型 */
    var channel_model = WPCreditChannelModel()
    
    /**  选择信用卡模型 */
    var credit_model = WPBankCardModel()
    
    /**  选择储蓄卡模型 */
    var deposit_model = WPBankCardModel()
    

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPCreditRechargeCell", bundle: nil), forCellReuseIdentifier: WPCreditRechargeCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPCreditRechargeCell = tableView.dequeueReusableCell(withIdentifier: WPCreditRechargeCellID, for: indexPath) as! WPCreditRechargeCell
        cell.credit_model = credit_model
        cell.deposit_model = deposit_model
        cell.selectA_button.addTarget(self, action: #selector(self.selectCreditAction), for: .touchUpInside)
        cell.selectB_button.addTarget(self, action: #selector(self.selectDepositAction), for: .touchUpInside)
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return cell
    }
    
    
    // MARK: - Action
    
    //选择信用卡
    @objc func selectCreditAction() {
        popToSelectCard(title: "选择信用卡", type: "5")
    }
    
    //选择储蓄卡
    @objc func selectDepositAction() {
        popToSelectCard(title: "选择储蓄卡", type: "3")
    }
    
    //跳转去选择银行卡
    func popToSelectCard(title: String, type: String) {
        let vc = WPBankCardListController()
        vc.showCardType = type
        vc.navigationItem.title = title
        weak var weakSelf = self
        vc.selectedCardInfor = {(model) -> Void in
            let cell: WPCreditRechargeCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPCreditRechargeCell
            switch title {
            case "选择信用卡":
                weakSelf?.credit_model = model
                cell.credit_model = model
            case "选择储蓄卡":
                weakSelf?.deposit_model = model
                cell.deposit_model = model
            default:
                break
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //下一步
    @objc func nextAction() {
        weak var weakSelf = self
        WPPayTool.pay { (password) in
            switch weakSelf?.channel_model.id {
            case 3?: //通道A
                weakSelf?.postCreditRechargeData(password: password, money: (weakSelf?.money)!)
            case 12?: //通道B
                weakSelf?.postCreditRechargeBData(password: password, money: (weakSelf?.money)!)
            default:
                break
            }
        }
    }
    
    // MARK: - Request
    
    /**  获取信用卡 */
    func getCreditCardData() {
        weak var weakSelf = self
        WPBankCardModel.loadData(clitype: "5", success: { (dataArray) in
            if dataArray.count > 0 {
                weakSelf?.credit_model = dataArray[0] as! WPBankCardModel
            }
            weakSelf?.tableView.reloadData()
        }) { (error) in
        }
    }
    
    /**  获取储蓄卡 */
    func getDepositCardData() {
        weak var weakSelf = self
        WPBankCardModel.loadData(clitype: "3", success: { (dataArray) in
            if dataArray.count > 0 {
                weakSelf?.deposit_model = dataArray[0] as! WPBankCardModel
            }
            weakSelf?.tableView.reloadData()
        }) { (error) in
        }
    }
    
    /**  信用卡充值(通道A) */
    func postCreditRechargeData(password: String, money: String) {
        let urlString: String = WPBaseURL + "/" + WPCreditRechargeURL
        
        let parameter = ["clientId" : WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) ?? "",
                         "rechargeAmount" : money,
                         "receiveCardId" : deposit_model.id,
                         "payCardId" : credit_model.id,
                         "payPassword" : password,
                         "chanelId" : channel_model.id] as [String : Any]
        WPProgressHUD.showProgress(status: WPAppName)
        weak var weakSelf = self
        Alamofire.request(urlString, method: .post, parameters: parameter).responseJSON { (response) in
            WPProgressHUD.dismiss()
            switch response.result {
            case.success(let value):
                let result: NSDictionary = (value as! NSDictionary)["result"] as! NSDictionary
                if result["err_msg"] != nil {
                    WPProgressHUD.showInfor(status: (result["err_msg"] as? String)!)
                }
            case.failure( _):
                if (response.data?.count)! > 0 {
                    // Data -> String
                    var dataString: String = String.init(data: response.data!, encoding: String.Encoding.utf8)!
                    dataString = dataString.replacingOccurrences(of: "\n", with: "\\n")
                    
                    let vc = WPRechargeWebViewController()
                    vc.channel_url = dataString
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    WPProgressHUD.showError(status: "网络错误")
                }
            }
        }
    }
    
    /**  信用卡充值(通道B) */
    func postCreditRechargeBData(password: String, money: String) {
        let parameter = [ "rechargeAmount" : money,
                          "receiveCardId" : deposit_model.id,
                          "payCardId" : credit_model.id,
                          "payPassword" : password,
                          "chanelId" : channel_model.id] as [String : Any]
        WPProgressHUD.showProgress(status: WPAppName)
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPCreditRechargeBURL, parameters: parameter, success: { (result) in
            let model: WPCreditChannelBModel = WPCreditChannelBModel.mj_object(withKeyValues: result)
            switch model.code {
            case "wlb_02":
                let vc = WPPasswordAuthCodeController()
                vc.phoneNumber = "请输入您收到的验证码"
                vc.authCodeType = 4
                vc.channel_dic = parameter as NSDictionary
                vc.channel_model = model
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = WPRechargeChannelBWebViewController()
                vc.channel_url = model.openCardUrl
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (error) in
            
        }
    }
    
    /**  判断支付密码是否正确 */
    func postCheckPayPasswordData(password: String) {
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPCheckPayPasswordURL, parameters: ["payPassword" : password], success: { (result) in
            let vc = WPCreditInputInforController()
            vc.initInfor(password: password, money: (weakSelf?.money)!, creditModel: (weakSelf?.credit_model)!, depositModel: (weakSelf?.deposit_model)!, channelModel: (weakSelf?.channel_model)!)
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }

}
