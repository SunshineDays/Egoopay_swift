//
//  WPBenefitBalanceController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBenefitBalanceController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "分润余额"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提现记录", style: .plain, target: self, action: #selector(self.rightAction))
        self.tableView.register(UINib.init(nibName: "WPBenefitsBalanceCell", bundle: nil), forCellReuseIdentifier: WPBenefitsBalanceCellID)
        self.tableView.separatorStyle = .none
        getAgencyInforData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var agency_model = WPAgencyModel()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPBenefitsBalanceCell = tableView.dequeueReusableCell(withIdentifier: WPBenefitsBalanceCellID, for: indexPath) as! WPBenefitsBalanceCell
        cell.model = agency_model
        cell.confirm_button.addTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    // MARK: - Action
    
    @objc func rightAction() {
        self.navigationController?.pushViewController(WPBenefitBalanceWithDrawRecordController(), animated: true)
    }
    
    @objc func confirmButtonAction() {
        let cell: WPBenefitsBalanceCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPBenefitsBalanceCell
        if Float(cell.money_textField.text!)! < 100 {
            WPProgressHUD.showInfor(status: "转出金额不能低于100元")
        }
        else if Float(cell.money_textField.text!)! > agency_model.benefitBalance {
            WPProgressHUD.showInfor(status: "转出金额超限")
        }
        else {
            weak var weakSelf = self
            WPPayTool.pay(password: { (password) in
                weakSelf?.postWithBenefitBalanceData(password: password, money: cell.money_textField.text!)
            })
        }
    }
    
    //MARK: - Request
    
    @objc func getAgencyInforData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPAgencyURL, parameters: nil, superview: self.view, view: self.noResultView, success: { (result) in
            weakSelf?.agency_model = WPAgencyModel.mj_object(withKeyValues: result)
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()
        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getAgencyInforData), for: .touchUpInside)
        }) { (error) in
            
        }
    }
    
    func postWithBenefitBalanceData(password: String, money: String) {
        let parameter = ["withdrawAmount" : money,
                         "payPassword" : password]
        
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPProfitWithdrawURL, parameters: parameter, success: { (result) in
            WPInterfaceTool.showResultView(title: "转出成功", money: Float(money)!, payState: "分润余额转出到账户余额")
        }) { (error) in

        }
    }

}
