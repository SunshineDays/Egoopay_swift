//
//  WPSubAccountAddController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/1.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSubAccountAddController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        if isChangePassword {
            self.navigationItem.title = "修改密码"
            placeholder_array = [String(format: "%ld", clerkId), "请输入新密码(不少于6位)", "请确认密码"]
            content_array.addObjects(from: [String(format: "%ld", clerkId), "", ""])
        }
        else {
            self.navigationItem.title = "添加子账户"
            placeholder_array = ["请设置子账户名称", "请设置登录密码(不少于6位)", "请确认密码"]
            content_array.addObjects(from: ["", "", ""])
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if content_array[1] as? String != "" {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**  判断是否是修改密码 */
    var isChangePassword = false
    
    var clerkId = NSInteger()
    
    let image_array = [#imageLiteral(resourceName: "icon_people"), #imageLiteral(resourceName: "icon_block"), #imageLiteral(resourceName: "icon_block")]
    
    var placeholder_array = NSArray()
    
    let content_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPImageTextFieldCell", bundle: nil), forCellReuseIdentifier: WPImageTextFieldCellID)
        tableView.register(UINib.init(nibName: "WPConfirmButtonCell", bundle: nil), forCellReuseIdentifier: WPConfirmButtonCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image_array.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == image_array.count ? 80 : 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case image_array.count:
            let cell: WPConfirmButtonCell = tableView.dequeueReusableCell(withIdentifier: WPConfirmButtonCellID, for: indexPath) as! WPConfirmButtonCell
            cell.confirm_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
            cell.confirm_button.setTitle(isChangePassword ? "确认修改" : "下一步", for: .normal)
            tableView.separatorStyle = .none
            return cell
        default:
            let cell: WPImageTextFieldCell = tableView.dequeueReusableCell(withIdentifier: WPImageTextFieldCellID, for: indexPath) as! WPImageTextFieldCell
            cell.title_imageView.image = image_array[indexPath.row]
            cell.title_textField.placeholder = placeholder_array[indexPath.row] as? String
            cell.title_textField.tag = indexPath.row
            cell.title_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingChanged)
            switch indexPath.row {
            case 0:
                if !isChangePassword {
                    cell.title_textField.becomeFirstResponder()
                }
                else {
                    cell.isUserInteractionEnabled = false
                }
            case 1:
                if isChangePassword {
                    cell.title_textField.becomeFirstResponder()
                }
                cell.title_textField.isSecureTextEntry = true

            default:
                cell.title_textField.isSecureTextEntry = true
            }
            return cell
        }
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
    
    @objc func textFieldAction(_ textField: UITextField) {
        content_array.replaceObject(at: textField.tag, with: textField.text!)
        WPInterfaceTool.changeButtonColor(tableView: tableView, row: 3, section: 0, array:content_array)
    }
    
    @objc func nextAction() {
        if ((content_array[1] as? String)?.count)! < 6 {
            WPProgressHUD.showInfor(status: "登录密码不能少于6位")
        }
        else if (content_array[1] as? String) != (content_array[2] as? String) {
            WPProgressHUD.showInfor(status: "两次输入的密码不一致")
        }
        else {
            isChangePassword ? postSubAccountPasswordData() : postSubAccountAddData()
        }
    }
    
    // MARK: - Request
    
    /**  添加子账户 */
    func postSubAccountAddData() {
        let parameter = ["clerkName" : content_array[0] as? String,
                         "password" : WPPublicTool.base64EncodeString(string: (content_array[1] as? String)!)]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPSubAccountAddURL, parameters: parameter as Any as? [String : Any], success: { (result) in
            let vc = WPSubAccountDetailController()
            vc.listModel.clerkId = (result["clerkId"] as? NSInteger)!
            vc.listModel.clerkNo = (result["clerkNo"] as? NSInteger)!
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }
    
    /**  更改子账户密码  */
    func postSubAccountPasswordData() {
        let parameter = ["clerkId" : clerkId,
                         "password" : WPPublicTool.base64EncodeString(string: (content_array[1] as? String)!)] as [String : Any]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPSubAccountChangePasswordURL, parameters: parameter, success: { (result) in
            weakSelf?.navigationController?.popViewController(animated: true)
            WPProgressHUD.showSuccess(status: "修改成功")

        }) { (error) in
            
        }
    }
    
}
