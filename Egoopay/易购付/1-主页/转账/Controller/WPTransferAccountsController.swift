//
//  WPTransferAccountsController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPTransferAccountsController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "转到易购付账户"
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var phone = String()

    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "WPInputTextFieldCell", bundle: nil), forCellReuseIdentifier: WPInputTextFieldCellID)
        tableView.register(UINib.init(nibName: "WPConfirmButtonCell", bundle: nil), forCellReuseIdentifier: WPConfirmButtonCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPInputTextFieldCell = tableView.dequeueReusableCell(withIdentifier: WPInputTextFieldCellID, for: indexPath) as! WPInputTextFieldCell
            cell.title_label.text = "对方账户"
            cell.content_textField.keyboardType = UIKeyboardType.numberPad
            cell.content_textField.becomeFirstResponder()
            cell.content_textField.placeholder = "易购付账户／手机号码"
            cell.content_textField.addTarget(self, action: #selector(self.textFieldAction), for: UIControlEvents.editingChanged)
            return cell
        default:
            let cell: WPConfirmButtonCell = tableView.dequeueReusableCell(withIdentifier: WPConfirmButtonCellID, for: indexPath) as! WPConfirmButtonCell
            cell.confirm_button.addTarget(self, action: #selector(self.jumpToNextVc), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 15 : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        if section == 1 {
            let label = UILabel(frame: CGRect(x: WPLeftMargin, y: 0, width: kScreenWidth - 2 * WPLeftMargin, height: 30))
            label.text = "钱将实时转入对方账户，无法退款"
            label.textColor = UIColor.gray
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 12)
            view.addSubview(label)
        }
        return view
    }
    
    // MARK: - Action
    
    @objc func textFieldAction(textField: UITextField) {
        phone = textField.text!
        WPInterfaceTool.changeButtonColor(tableView: tableView, row: 0, section: 1, array: [phone])
    }
    
    @objc func jumpToNextVc() {
        if !WPJudgeTool.validate(mobile: phone) {
            WPProgressHUD.showInfor(status: "手机号码格式错误")
        }
        else {
            if phone == WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) {
                WPProgressHUD.showInfor(status: "不能给自己转账")
            }
            else {
                PostPhoneData()
            }
        }
    }
    
    // MARK: - Request
    
    /**  判断手机号是否是易购付账户 */
    func PostPhoneData() {
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPJudgePhoneURL, parameters: ["phone" : phone], success: { (success) in
            let vc = WPTransferFriendController()
            vc.phone = (weakSelf?.phone)!
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }


}
