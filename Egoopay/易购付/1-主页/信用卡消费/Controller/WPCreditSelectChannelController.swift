//
//  WPCreditSelectChannelController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/12.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPCreditSelectChannelController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "信用卡取现"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取现教程", style: .plain, target: self, action: #selector(self.rightItemAction))
        self.view.backgroundColor = UIColor.tableViewColor()
        self.view.addSubview(header_view)
        getChannelData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var data_array = NSMutableArray()
    
    lazy var header_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 15, width: kScreenWidth, height: 60))
        view.addSubview(self.title_label)
        view.addSubview(self.money_textField)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var title_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: WPLeftMargin, y: 0, width: 90, height: 60))
        label.text = "金额"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var money_textField: UITextField = {
        let textField = UITextField.init(frame: CGRect.init(x: 105, y: 0, width: kScreenWidth - self.title_label.frame.maxX - WPLeftMargin, height: 60))
        textField.placeholder = "请输入取现金额"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.decimalPad
//        textField.becomeFirstResponder()
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY + 75, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 75), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPCreditSelectChannelCell", bundle: nil), forCellReuseIdentifier: WPCreditSelectChannelCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPCreditSelectChannelCell = tableView.dequeueReusableCell(withIdentifier: WPCreditSelectChannelCellID, for: indexPath) as! WPCreditSelectChannelCell
        cell.model = data_array[indexPath.row] as! WPCreditChannelModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewColor()
        let label = UILabel.init(frame: CGRect.init(x: WPLeftMargin, y: 5, width: 200, height: 20))
        label.text = "请选择交易通道"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model: WPCreditChannelModel = data_array[indexPath.row] as! WPCreditChannelModel
        if money_textField.text?.count == 0 {
            WPProgressHUD.showInfor(status: "请输入提现金额")
        }
        else {
            if Float(money_textField.text!)! < model.minAmount {
                WPProgressHUD.showInfor(status: String(format:"该通道最低提现金额为：%.2f元", model.minAmount))
            }
            else if Float(money_textField.text!)! > model.maxAmount {
                WPProgressHUD.showInfor(status: String(format:"该通道最高提现金额为：%.2f元", model.maxAmount))
            }
            else {
                let vc = WPCreditRechargeController()
                vc.channel_model = model
                vc.money = money_textField.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text, range: range, replacementString: string)
    }
    
    // MAARK: - Action
    
    @objc func rightItemAction() {
        let vc = WPPictureIntroController()
        vc.navigationItem.title = "取现流程"
        vc.intro_image = #imageLiteral(resourceName: "icon_quxianliucheng")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Request
    
    func getChannelData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPCreditChannelURL, parameters: nil, success: { (result) in
            let resultModel = WPCreditChannelResultModel.mj_object(withKeyValues: result)
            weakSelf?.data_array.addObjects(from: WPCreditChannelModel.mj_objectArray(withKeyValuesArray: resultModel?.list) as! [Any])
            
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
}
