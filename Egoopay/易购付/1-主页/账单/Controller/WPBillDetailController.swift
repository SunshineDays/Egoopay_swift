//
//  WPBillDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBillDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "账单详情"
        if bill_model.orderno.count > 0 {
            initWay(id: bill_model.tradeType)
        }
        else {
            getBillDetailData(orderNo: orderNo)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var orderNo = String()
    
    var title_array = NSMutableArray()
    
    var content_array = NSMutableArray()
    
    var bill_model = WPBillInforListModel()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPBillDetailHeaderCell", bundle: nil), forCellReuseIdentifier: WPBillDetailHeaderCellID)
        tableView.register(UINib.init(nibName: "WPBillDetailContentCell", bundle: nil), forCellReuseIdentifier: WPBillDetailContentCellID)
        tableView.register(UINib.init(nibName: "WPTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? title_array.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell: WPBillDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: WPBillDetailHeaderCellID, for: indexPath) as! WPBillDetailHeaderCell
            cell.model = bill_model
            return cell
        case 1:
            let cell: WPBillDetailContentCell = tableView.dequeueReusableCell(withIdentifier: WPBillDetailContentCellID, for: indexPath) as! WPBillDetailContentCell
            cell.title_label.text = title_array[indexPath.row] as? String
            cell.content_label.text = content_array[indexPath.row] as? String
            return cell
        default:
            let cell: WPTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCellID, for: indexPath) as! WPTitleCell
            cell.title_label.text = "对此单有疑问"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 15 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        if indexPath.section == 2 {
            WPInterfaceTool.alertController(title: "请选择", rowOneTitle: "客服电话", rowTwoTitle: "客服QQ", rowOne: { (action) in
                WPInterfaceTool.callToNum(numString: WPAppTelNumber)
            }, rowTwo: { (action) in
                if UIApplication.shared.canOpenURL(URL.init(string: "mqq://")!) {
                    let webView = UIWebView.init(frame: CGRect.zero)
                    let url = URL.init(string: "mqq://im/chat?chat_type=wpa&uin=" + WPAppQQNumber + "&version=1&src_type=web")
                    let request = URLRequest.init(url: url!)
                    webView.delegate = self
                    webView.loadRequest(request)
                    self.view.addSubview(webView)
                }
                else {
                    WPProgressHUD.showInfor(status: "您还没有安装QQ")
                }
                
            })
            
        }
    }

    
    
    
    func initWay(id: NSInteger) {
        var arrayA = NSArray()
        var arrayB = NSArray()
        switch id {
        case 1: //充值
            arrayA = ["充值方式", "到账账户"]
            arrayB = [bill_model.payMethodName, "账户余额"]
        case 2: //转账
            arrayA = ["转账方式", "到账账户"]
            arrayB = [bill_model.payMethodName, "易购付账户"]
        case 3: //信用卡消费
            arrayA = ["消费信用卡", "到账储蓄卡", "手续费"]
            arrayB = [bill_model.payCardNum == "" ? "信用卡" : bill_model.payCardName + String(format: "(%@)", bill_model.payCardNum), bill_model.receiveCardNum == "" ? "储蓄卡" : bill_model.receiveCardName + String(format: "(%@)", bill_model.receiveCardNum), String(format: "%.2f", bill_model.counterFee)]
        case 4: //余额提现
            arrayA = ["提现到"]
            arrayB = [bill_model.receiveCardNum == "" ? "储蓄卡" : bill_model.receiveCardName + String(format: "(%@)", bill_model.receiveCardNum)]
        case 5: //付款
            arrayA = ["付款方式", "付款说明"]
            arrayB = [bill_model.payMethodName, bill_model.remark]
        case 6: //二维码收款
            arrayA = ["收款方式", "收款说明"]
            arrayB = [bill_model.payMethodName, bill_model.remark]
        case 7: //退款
            arrayA = ["到账账户", "退款说明"]
            arrayB = ["账户余额", bill_model.remark]
        case 8: //分润提现
            arrayA = ["提现到"]
            arrayB = ["账户余额"]
        case 9, 10: //商户升级、代理升级
            arrayA = ["付款方式", "付款说明"]
            arrayB = [bill_model.payMethodName, bill_model.remark]
        case 11, 12: //话费充值、流量充值
            arrayA = ["付款方式", "付款说明", "充值号码"]
            arrayB = [bill_model.payMethodName, bill_model.remark, bill_model.phone]
        default:
            arrayA = ["付款方式", "付款说明"]
            arrayB = [bill_model.payMethodName, bill_model.remark]
        }
        title_array.addObjects(from: arrayA as! [Any])
        title_array.addObjects(from: ["", "创建时间", "订单编号"])
        
        content_array.addObjects(from: arrayB as! [Any])
        content_array.addObjects(from: ["", WPPublicTool.stringToDate(date: bill_model.createDate), bill_model.orderno])
        
        tableView.reloadData()
    }
    
    
    func getBillDetailData(orderNo: String) {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPBillDetailURL, parameters: ["orderNo" : orderNo], success: { (result) in
            weakSelf?.bill_model = WPBillInforListModel.mj_object(withKeyValues: result["order"])
            weakSelf?.initWay(id: (weakSelf?.bill_model.tradeType)!)
        }) { (error) in
            
        }
    }
    
}
