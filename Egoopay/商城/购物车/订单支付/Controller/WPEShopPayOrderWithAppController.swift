//
//  WPEShopPayOrderWithAppController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopPayOrderWithAppController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "支付订单"
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_goBack_goBack"), style: .plain, target: self, action: #selector(self.popToViewController))
        tableView.reloadData()
        self.view.addSubview(pay_button)
        NotificationCenter.default.post(name: WPNotificationEShopPostOrderSuccess, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    /**  总价(获取) */
    var totalMoney = Double()
    
    /**  订单模型(获取) */
    var order_model = WPEShopPayOrderDetailModel()
    
    /**  默认选择第0行 */
    var selectedRow = 0
    
    let app_array = ["银行卡支付", "余额支付", "支付宝支付", "微信支付", "QQ钱包支付"]
    
    let image_array = [#imageLiteral(resourceName: "icon_payWithBankCard"), #imageLiteral(resourceName: "icon_payWithBalance"), #imageLiteral(resourceName: "icon_payWithApliy"), #imageLiteral(resourceName: "icon_payWithWeChat"), #imageLiteral(resourceName: "icon_payWithQQ")]
    
    lazy var header_view: WPEShopPayOrderWithAppHeaderView = {
        let view = WPEShopPayOrderWithAppHeaderView()
        view.initInfor(price: totalMoney, orderId: order_model.order_info_id)
        return view
    }()
    
    lazy var pay_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - 55, width: kScreenWidth, height: 55))
        button.backgroundColor = UIColor.themeEShopColor()
        button.setTitle(String(format: "确认支付 ￥%.2f", totalMoney), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button.addTarget(self, action: #selector(self.payAction), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 55), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableHeaderView = self.header_view
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: "WPEShopPayOrderWithAppCell", bundle: nil), forCellReuseIdentifier: WPEShopPayOrderWithAppCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return app_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopPayOrderWithAppCell = tableView.dequeueReusableCell(withIdentifier: WPEShopPayOrderWithAppCellID, for: indexPath) as! WPEShopPayOrderWithAppCell
        cell.appName_label.text = app_array[indexPath.section]
        cell.appName_label.textColor = indexPath.section == 0 ? UIColor.black : UIColor.darkGray
        cell.appName_label.font = indexPath.section == 0 ? UIFont.systemFont(ofSize: 19, weight: UIFont.Weight(rawValue: 2)) : UIFont.systemFont(ofSize: 16)
        cell.app_imageView.image = image_array[indexPath.section]
        cell.select_iamgeView.image = indexPath.section == selectedRow ? #imageLiteral(resourceName: "icon_eShopShoppingCart_selected") : #imageLiteral(resourceName: "icon_eShopShoppingCart_default")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 15 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.section
        tableView.reloadData()
    }
    
    // MARK: - Action
    
    @objc func popToViewController() {
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: "您还没有完成支付，确认离开？", confirmTitle: "确认离开", confirm: { (action) in
            weakSelf?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            weakSelf?.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: WPNotificationEShopOrderPayUnFinishedPushToOrderList, object: nil)
        }) { (actin) in
            
        }
    }
    
    @objc func payAction() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        switch selectedRow {
        case 0: //银行卡支付
            payWithBankCard()
        case 1, 2, 3, 4: //余额/app支付
            print("123")
            weak var weakSelf = self
            let appName = app_array[selectedRow]
            WPPayTool.pay(password: { (password) in
                weakSelf?.postPayWithOrderData(payMethod: WPInforTypeTool.appID(appName: appName), password: password)
            })
        default:
            break
        }
    }

    
    //银行卡支付
    func payWithBankCard() {
        let vc = WPPayWithBankCardController()
        let clientId = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_clientID) ?? ""
        vc.webUrl_string = WPPayWithBankCardURL + "?" + "clientId=" + clientId + "&billNo=" + order_model.order_info_id + "&tradeType=13" + "&amount=" + String(format: "%.2f", totalMoney)
        WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
    }
    
    //余额/app支付
    func postPayWithOrderData(payMethod: String, password: String) {
        let parameter = ["orderNo" : order_model.order_info_id,
                         "payPassword" : password,
                         "payMethod" : payMethod,
                         "amount" : String(format: "%.2f", totalMoney)] as [String : Any]
        weak var weakSelf = self
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(baseUrl: WPBaseURL, url: WPEShopPayOrderURL, parameters: parameter, success: { (result) in
            if payMethod == "4" {//余额支付
                weakSelf?.navigationController?.popToRootViewController(animated: true)
                WPProgressHUD.showSuccess(status: "支付成功")
                NotificationCenter.default.post(name: WPNotificationEShopOrderPayUnFinishedPushToOrderList, object: nil)
            }
            else {
                WPInterfaceTool.showPayCodeView(result: result)
            }
        }) { (error) in
            
        }

    }
    
}
