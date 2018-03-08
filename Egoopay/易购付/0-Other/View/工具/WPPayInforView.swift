//
//  WPPayInforView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPayInforView: UIView, UITableViewDelegate, UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var wayName = String()
    
    var result_model = WPOrderResultModel()
    
    var order_model = WPOrderModel()
    
    func initInfor(result: NSDictionary) {
        let result_model: WPOrderResultModel = WPOrderResultModel.mj_object(withKeyValues: result)
        order_model = WPOrderModel.mj_object(withKeyValues: result_model.order)
        wayName = "银行卡支付"
        tableView.reloadData()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2) {
            weakSelf?.tableView.frame = CGRect.init(x: 0, y: kScreenHeight - WPpopupViewHeight, width: kScreenWidth, height: WPpopupViewHeight)
        }
    }

    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: WPpopupViewHeight), style: .plain)
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPPayInforCell", bundle: nil), forCellReuseIdentifier: WPPayInforCellID)
        self.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPPayInforCell = tableView.dequeueReusableCell(withIdentifier: WPPayInforCellID, for: indexPath) as! WPPayInforCell
        cell.wayName = wayName
        cell.model = order_model
        
        cell.cancel_button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        cell.payWay_button.addTarget(self, action: #selector(self.goToSelectPayWayAction), for: .touchUpInside)
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WPpopupViewHeight
    }
    
    // MARK: - Action
    
    @objc func goToSelectPayWayAction() {
        let view = WPPayInforWayView()
        UIApplication.shared.keyWindow?.addSubview(view)
        weak var weakSelf = self
        view.selectPayWayType = {(wayName) -> Void in
            weakSelf?.wayName = wayName
            let cell: WPPayInforCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPPayInforCell
            cell.payWay_label.text = wayName
        }
        
        view.cancelPayWayType = {
            UIView.animate(withDuration: 0.25) {
                weakSelf?.tableView.frame = CGRect.init(x: 0, y: kScreenHeight - WPpopupViewHeight, width: kScreenWidth, height: WPpopupViewHeight)
            }
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.tableView.frame = CGRect(x: -kScreenWidth, y: kScreenHeight - WPpopupViewHeight, width: kScreenWidth, height: WPpopupViewHeight)
        }) { (finished) in
//            self.removeFromSuperview()
        }
        
    }
    
    @objc func confirmAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissView), name: WPNotificationRemovePayInforView, object: nil)
        if wayName == "银行卡支付" {
            postPayOrderWithBankCardData()
        }
        else {
            weak var weakSelf = self
            WPPayTool.pay { (password) in
                weakSelf?.postPayWithOrderData(payMethod: WPInforTypeTool.appID(appName: (weakSelf?.wayName)!), password: password)
            }
        }
        
        
        
    }
    
    @objc func dismissView() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf?.tableView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: WPpopupViewHeight)
            weakSelf?.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
            NotificationCenter.default.removeObserver(self, name: WPNotificationRemovePayInforView, object: nil)
        }
    }
    
    
    // MARK: - Request
    
    //余额/app支付
    func postPayWithOrderData(payMethod: String, password: String) {
        let parameter = ["orderNo" : order_model.orderno,
                         "payPassword" : password,
                         "payMethod" : payMethod] as [String : Any]
        weak var weakSelf = self
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPPayOrderURL, parameters: parameter, success: { (result) in
            weakSelf?.dismissView()
            if weakSelf?.wayName == "余额支付" {
                WPInterfaceTool.showResultView(title: "支付成功", money: (weakSelf?.order_model.amount)!, payState: (weakSelf?.order_model.remark)!)
            }
            else {
                WPInterfaceTool.showPayCodeView(result: result)
            }
        }) { (error) in

        }
    }
    
    //银行卡支付
    func postPayOrderWithBankCardData() {
        self.dismissView()
        let vc = WPPayWithBankCardController()
        let clientId = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) ?? ""
        vc.webUrl_string = WPPayWithBankCardURL + "?" + "clientId=" + clientId + "&billNo=" + order_model.orderno + "&tradeType=13" + "&amount=" + String(format: "%.2f", order_model.amount)
        WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
    }

}
