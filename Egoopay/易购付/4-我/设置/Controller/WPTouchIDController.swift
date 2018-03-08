//
//  WPTouchIDController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPTouchIDCellID = "WPTouchIDCellID"

class WPTouchIDController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "安全管理"
        switch_array.addObjects(from: [WPJudgeTool.isOpenTouchIDPay()])
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let title_array = ["指纹支付"]
    var switch_array = NSMutableArray()
    
    lazy var header_view: WPTouchIDHeaderView = {
        let view = WPTouchIDHeaderView()
        view.protocol_button.addTarget(self, action: #selector(self.protocolAction), for: .touchUpInside)
        return view
    }()
    
    lazy var footer_label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: WPRowHeight))
        label.text = "开通后，可使用Touch ID验证指纹快速完成登录或支付"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableHeaderView = self.header_view
        tempTableView.tableFooterView = UIView()
        tempTableView.register(UINib.init(nibName: "WPTouchIDCell", bundle: nil), forCellReuseIdentifier: WPTouchIDCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.title_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPTouchIDCell = tableView.dequeueReusableCell(withIdentifier: WPTouchIDCellID, for: indexPath) as! WPTouchIDCell
        cell.title_label.text = title_array[indexPath.row]
        cell.select_switch.tag = indexPath.row
        cell.select_switch.setOn(switch_array[indexPath.row] as! Bool, animated: true)
        cell.select_switch.addTarget(self, action: #selector(self.swithValueChanged(_:)), for: UIControlEvents.valueChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

    //MARK: - Action
    
    @objc func protocolAction() {
        WPInterfaceTool.showWebViewController(url: WPTouchIDWebURL, title: "易购付指纹相关协议")
    }
    
    
    @objc func swithValueChanged(_ click: UISwitch) {
        switch click.tag {
        case 0:
            if WPJudgeTool.isOpenTouchID() {
                weak var weakSelf = self
                self.tableView.reloadData()
                WPPayTool.payView(password: { (password) in
                    weakSelf?.postValidatePasswordData(password: password)
                })
            }
            else {
                WPProgressHUD.showInfor(status: "当前设备不支持指纹识别")
                self.tableView.reloadData()
            }
        default:
            break
        }
        
    }
    
    //MARK: - Request
    func postValidatePasswordData(password: String) {
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPCheckPayPasswordURL, parameters: ["payPassword" : password], success: { (success) in
            weakSelf?.switch_array.replaceObject(at: 0, with: !WPJudgeTool.isOpenTouchIDPay())
            weakSelf?.tableView.reloadData()
            WPUserDefaults.userDefaultsSave(key: WPUserDefaults_touchIDPay, value: weakSelf?.switch_array[0] as! Bool ? "YES" : nil)
            WPKeyChainTool.keyChainSave(password, forKey: WPKeyChain_payPassword)
            UserDefaults.standard.synchronize()
        }) { (error) in
            
        }
    }
    
}
