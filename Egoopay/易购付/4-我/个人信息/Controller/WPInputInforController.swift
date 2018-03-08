//
//  WPInputInforController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/19.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPInputInforType = (_ inputInfor : String) -> Void

let WPInputInforCellID = "WPInputInforCellID"

class WPInputInforController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确认", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.confirmAction))
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var inputInfor: WPInputInforType?
    
    var textField_string = String()
    
    lazy var header_view: UIView = {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 40)
        return tempView
    }()
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.tableHeaderView = self.header_view
        tempTableView.tableFooterView = UIView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UINib.init(nibName: "WPInputInforCell", bundle: nil), forCellReuseIdentifier: WPInputInforCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPInputInforCell = tableView.dequeueReusableCell(withIdentifier: WPInputInforCellID, for: indexPath) as! WPInputInforCell
        cell.title_textField.placeholder = "请输入信息"
        cell.title_textField.text = self.textField_string
        cell.title_textField.becomeFirstResponder()
        cell.title_textField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField_string = textField.text!
    }
    
    
    // MARK: - Action
    @objc func confirmAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
        if self.navigationItem.title == "详细地址" && self.textField_string.count == 0 {
            WPProgressHUD.showInfor(status: "请输入地址")
            self.tableView.reloadData()
        }
        else if self.navigationItem.title == "更换邮箱" && !WPJudgeTool.validate(email: self.textField_string) {
            WPProgressHUD.showInfor(status: "邮箱格式错误")
            self.tableView.reloadData()
        }
        else {
            self.inputInfor?(self.textField_string)
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}
