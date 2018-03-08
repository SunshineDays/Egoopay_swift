//
//  WPAppsRechargeController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/7.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPAppsRechargeController: WPBaseViewController,UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "充值"
        getUserRateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  充值费率模型 */
    var rate_model = WPUserRateModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPAppRechargeCell", bundle: nil), forCellReuseIdentifier: WPAppRechargeCellID)
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
        let cell: WPAppRechargeCell = tableView.dequeueReusableCell(withIdentifier: WPAppRechargeCellID, for: indexPath) as! WPAppRechargeCell
        cell.model = rate_model
        cell.select_button.addTarget(self, action: #selector(self.selectAction), for: .touchUpInside)
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WPHeaderInSectionClearView()
    }
    
    
    // MARK: - Action
    
    @objc func selectAction() {
        let vc = WPSelectAppController()
        weak var weakSelf = self
        vc.selectAppInfor = {(appName) -> Void in
            let cell: WPAppRechargeCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPAppRechargeCell
            cell.appName = appName
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextAction() {
        let cell: WPAppRechargeCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPAppRechargeCell
        if Double(cell.money_textField.text!) == 0 {
            WPProgressHUD.showInfor(status: "请输入充值金额")
        }
        else if Double(cell.money_textField.text!)! > 500.0 {
            WPProgressHUD.showInfor(status: "单笔交易金额不能超过500元")
        }
        else {
            postAppRechargeData(money: cell.money_textField.text!, appName: cell.appName_label.text!)
        }
    }
    

    // MARK: - Request
    
    /**  获取充值费率 */
    func getUserRateData() {
        weak var weakSelf = self
        WPUserRateModel.getData { (model) in
            weakSelf?.rate_model = model
            weakSelf?.tableView.reloadData()
        }
    }
    
    func postAppRechargeData(money: String, appName: String) {
        let parameter = ["rechargeAmount" : money,
                         "payMethod" : WPInforTypeTool.appID(appName: appName)]
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPAppRechargeURL, parameters: parameter, success: { (result) in
            WPInterfaceTool.showPayCodeView(result: result)
        }) { (error) in
            
        }
    }

}
