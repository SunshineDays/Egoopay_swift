//
//  WPPasswordSelectController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordSelectController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "密码设置"
        self.tableView.register(UINib.init(nibName: "WPPasswordSelectCell", bundle: nil), forCellReuseIdentifier: WPPasswordSelectCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let data_array = ["重置登录密码", "重置支付密码"]
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data_array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPPasswordSelectCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordSelectCellID, for: indexPath) as! WPPasswordSelectCell
        cell.title = data_array[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        WPPopToViewControllerName = self
        switch indexPath.row {
        case 0: //重置登录密码
            getAuthCodeData(title: data_array[indexPath.row])
        default: //重置支付密码
            weak var weakSelf = self
            WPLoadDataModel.getUserApproveStateData(approveType: true) { (isPass) in
                if WPJudgeTool.isSetPayPassword() {
                    weakSelf?.getAuthCodeData(title: (weakSelf?.data_array[indexPath.row])!)
                }
                else {
                    WPPayTool.goToSetPayPassword()
                }
            }
        }
    }
    
    
    func getAuthCodeData(title: String) {
        let parameter = ["phone" : WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!, "verType" : "2"]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPAuthCodeURL, parameters: parameter, success: { (result) in
            let vc = WPPasswordAuthCodeController()
            vc.authCodeType = title == weakSelf?.data_array[0] ? 1 : 2
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }

}
