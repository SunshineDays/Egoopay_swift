//
//  WPWithDrawController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPWithDrawController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "提现"
        self.tableView.register(UINib.init(nibName: "WPSelectCardCell", bundle: nil), forCellReuseIdentifier: WPSelectCardCellID)
        self.tableView.register(UINib.init(nibName: "WPWithDrawCell", bundle: nil), forCellReuseIdentifier: WPWithDrawCellID)
        self.tableView.separatorStyle = .none
        getUserInforData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  选择的储蓄卡的model */
    var deposit_model = WPBankCardModel()
    
    /**  用户信息模型 */
    var infor_model = WPUserInforModel()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPSelectCardCell = tableView.dequeueReusableCell(withIdentifier: WPSelectCardCellID, for: indexPath) as! WPSelectCardCell
            cell.model = deposit_model
            return cell
        default:
            let cell: WPWithDrawCell = tableView.dequeueReusableCell(withIdentifier: WPWithDrawCellID, for: indexPath) as! WPWithDrawCell
            cell.model = infor_model
            cell.confirm_button.addTarget(self, action: #selector(self.confirmButtonAction), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            selectDepositCard()
        default:
            break
        }
    }
    
    // MARK: - Action
    
    /**  选择储蓄卡 */
    func selectDepositCard() {
        let vc = WPBankCardListController()
        vc.showCardType = "3"
        weak var weakSelf = self
        vc.selectedCardInfor = {(model) -> Void in
            weakSelf?.deposit_model = model
            weakSelf?.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        }
        vc.navigationItem.title = "请选择储蓄卡"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func confirmButtonAction() {
        let cell: WPWithDrawCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! WPWithDrawCell
        if Float(cell.money_textField.text!)! == 0 {
            WPProgressHUD.showInfor(status: "请输入金额")
        }
        else if Float(cell.money_textField.text!)! > infor_model.avl_balance {
            WPProgressHUD.showInfor(status: "转出金额超限")
        }
        else {
            weak var weakSelf = self
            WPPayTool.pay(password: { (password) in
                weakSelf?.postWithDrawData(password: password, money: cell.money_textField.text!)
            })
        }
    }

    // MARK: - Request
    
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (model) in
            weakSelf?.infor_model = model
            weakSelf?.getDepositCardData()
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
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()

        }) { (error) in
        }
    }
    
    /**  提交提现信息 */
    func postWithDrawData(password: String, money: String) {
        let parameter = ["withdrawAmount" : money,
                          "cardId" : deposit_model.id,
                          "payPassword" : password] as [String : Any]
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPWithdrawURL, parameters: parameter, success: { (success) in
            WPInterfaceTool.showResultView(title: "转出申请已提交，等待银行处理", money: Float(money)!, payState: "提现到银行卡")

        }) { (error) in

        }
    }

    
}
