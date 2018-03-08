//
//  WPSubAccountDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/1.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSubAccountDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "权限设置"
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "设置", style: .plain, target: self, action: #selector(self.rightItemAction))
        getSubAccountDetailData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  选中的子账户模型 */
    var listModel = WPSubAccountListModel()
    
    let title_array = ["今日收入", "收款码", "收款账单", "账单消息", "商家", "系统消息", "推荐", "余额", "银行卡"]
    
    /**  记录路权限信息 */
    let content_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPTouchIDCell", bundle: nil), forCellReuseIdentifier: WPTouchIDCellID)
        tableView.register(UINib.init(nibName: "WPConfirmButtonCell", bundle: nil), forCellReuseIdentifier: WPConfirmButtonCellID)

        self.view.addSubview(tableView)
        return tableView
    }()
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_array.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case title_array.count:
            return 80
        default:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case title_array.count:
            let cell: WPConfirmButtonCell = tableView.dequeueReusableCell(withIdentifier: WPConfirmButtonCellID, for: indexPath) as! WPConfirmButtonCell
            cell.confirm_button.setTitle("保存", for: .normal)
            cell.confirm_button.addTarget(self, action: #selector(self.saveAction), for: .touchUpInside)
            return cell
        default:
            let cell: WPTouchIDCell = tableView.dequeueReusableCell(withIdentifier: WPTouchIDCellID, for: indexPath) as! WPTouchIDCell
            cell.title_label.text = title_array[indexPath.row]
            cell.title_label.textColor = UIColor.darkGray
            cell.select_switch.setOn(content_array[indexPath.row] as? NSInteger == 1, animated: true)
            cell.select_switch.tag = indexPath.row
            cell.select_switch.addTarget(self, action: #selector(self.switchAction(_:)), for: .valueChanged)
            tableView.separatorStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: WPLeftMargin, y:0, width: kScreenWidth - 2 * WPLeftMargin,  height: 50))
        label.text = "子账户登录ID:" + String(format: "%ld", listModel.clerkNo)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    
    // MARK: - Action
    
    @objc func popToSubAccountVc() {
        WPInterfaceTool.popToViewController(controller: WPSubAccountController())
    }
    
    @objc func rightItemAction() {
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: nil, rowOneTitle: "删除子账户", rowTwoTitle: "重置密码", rowOne: { (alertAction) in
            WPInterfaceTool.alertController(title: "确定删除该子账户", confirmTitle: "删除", confirm: { (alertAction) in
                weakSelf?.postSubAccountDeleteData()
            }, cancel: { (alertAction) in
                
            })
        }) { (alertAction) in
            let vc = WPSubAccountAddController()
            vc.clerkId = (weakSelf?.listModel.clerkId)!
            vc.isChangePassword = true
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func switchAction(_ switchs: UISwitch) {
        content_array.replaceObject(at: switchs.tag, with: switchs.isOn ? 1 : 0)
    }
    
    @objc func saveAction() {
        postSubAccountDetailData()
    }
    
    
    // MARK: - Request
    
    /**  获取子账户权限信息 */
    func getSubAccountDetailData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPSubAccountJurisdictionURL, parameters: ["clerkId" : listModel.clerkId], success: { (result) in
            let model: WPSubAccountDetailModel = WPSubAccountDetailModel.mj_object(withKeyValues: result["resources"])
            weakSelf?.content_array.addObjects(from: [model.today_income, model.qr_pic, model.qr_bill, model.bill_msgs, model.mer_shops, model.sys_msgs, model.refer_pps, model.balance, model.bankcards])
            weakSelf?.tableView.reloadData()
            WPInterfaceTool.changeButtonColor(tableView: (weakSelf?.tableView)!, row: (weakSelf?.title_array.count)!, section: 0, array: ["OK"])
        }) { (error) in
            
        }
    }
    
    /**  提交子账户权限信息 */
    func postSubAccountDetailData() {
        let keyArray = ["today_income", "qr_pic", "qr_bill", "bill_msgs", "mer_shops", "sys_msgs", "refer_pps", "balance", "bankcards"]
        let parameter = NSMutableDictionary()
        parameter.addEntries(from: ["clerkId" : listModel.clerkId])
        for i in 0 ..< keyArray.count {
            parameter.addEntries(from: [keyArray[i] : content_array[i]])
        }
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPSubAccountSettingURL, parameters: parameter as? [String : Any], success: { (success) in
            WPInterfaceTool.popToViewController(controller: WPSubAccountController())
            WPProgressHUD.showSuccess(status: "设置成功")

        }) { (error) in
            
        }
    }
    
    /**  删除子账户 */
    func postSubAccountDeleteData() {
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPSubAccountDeleteURL, parameters: ["clerkId" : listModel.clerkId], success: { (success) in
            WPInterfaceTool.popToViewController(controller: WPSubAccountController())
            WPProgressHUD.showSuccess(status: "删除成功")

        }) { (error) in
            
        }
    }
}
