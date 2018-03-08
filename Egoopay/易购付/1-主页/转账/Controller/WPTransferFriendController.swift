//
//  WPTransferFriendController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPTransferFriendController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "转账"
        getUserInforData()
//        getUserRateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var phone = String()
    
    /**  充值费率 */
    var rate = Float()
    
    var money = String()
    
    var userInforModel = WPUserInforModel()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "WPTransferFriendCell", bundle: nil), forCellReuseIdentifier: WPTransferFriendCellID)
        tableView.register(UINib.init(nibName: "WPConfirmButtonCell", bundle: nil), forCellReuseIdentifier: WPConfirmButtonCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 240
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: WPTransferFriendCell = tableView.dequeueReusableCell(withIdentifier: WPTransferFriendCellID, for: indexPath) as! WPTransferFriendCell
            cell.title_imageView.sd_setImage(with: URL.init(string: userInforModel.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"), options: .refreshCached)
            cell.name_label.text = userInforModel.iscertified == 1 ? userInforModel.fullName + "(已实名)" : "未实名"
            cell.phone_label.text = WPPublicTool.stringStar(string: phone, headerIndex: 3, footerIndex: 4)
            cell.money_textField.becomeFirstResponder()
            cell.money_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: UIControlEvents.editingChanged)
            return cell
        default:
            let cell: WPConfirmButtonCell = tableView.dequeueReusableCell(withIdentifier: WPConfirmButtonCellID, for: indexPath) as! WPConfirmButtonCell
            cell.confirm_button.addTarget(self, action: #selector(self.jumpToNextVc), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    // MARK: - Action
    
    @objc func textFieldAction(_ textField: UITextField) {
        money = textField.text!
        WPInterfaceTool.changeButtonColor(tableView: tableView, row: 1, section: 0, array: [money])
    }
    
    @objc func jumpToNextVc() {
//        weak var weakSelf = self
        
    }
    
    // MARK: - Request
    
    
    func getUserInforData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPUserInforWithPhoneURL, parameters: ["phone" : phone], success: { (success) in
            weakSelf?.userInforModel = WPUserInforModel.mj_object(withKeyValues: success)
            weakSelf?.getUserRateData()
        }) { (error) in
            
        }
    }
    
    /**  获取充值费率 */
    func getUserRateData() {
        weak var weakSelf = self
        WPUserRateModel.getData { (rateModel) in
            weakSelf?.rate = rateModel.rate
            weakSelf?.tableView.reloadData()
        }
    }
    
    func postTransferData(payID: String, password: String) {
        let parameter = ["phone" : phone,
                         "transferAmount" : money,
                         "payMethod" : payID,
                         "cardId" : "",
                         "cnv" : "",
                         "payPassword" : password]
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPTransferAccountsURL, parameters: parameter, success: { (success) in
            WPInterfaceTool.showResultView(title: "转账成功", money: Float(self.money)!, payState: "转账")
        }) { (error) in
            
        }
    }

}
