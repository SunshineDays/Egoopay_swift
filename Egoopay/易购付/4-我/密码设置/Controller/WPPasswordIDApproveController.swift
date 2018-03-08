//
//  WPPasswordIDApproveController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordIDApproveController: WPBaseViewPlainController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "验证身份信息"
        tableView.register(UINib.init(nibName: "WPPasswordIDApproveCell", bundle: nil), forCellReuseIdentifier: WPPasswordIDApproveCellID)
        tableView.separatorStyle = .none
        getUserApproveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  身份信息模型 */
    var infor_model = WPUserApproveModel()
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPPasswordIDApproveCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordIDApproveCellID, for: indexPath) as! WPPasswordIDApproveCell
        cell.model = infor_model
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return cell
    }
 
    // MARK: - Action
    
    @objc func nextAction() {
        let cell: WPPasswordIDApproveCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPPasswordIDApproveCell
        if WPJudgeTool.validate(idCard: cell.number_textField.text!) {
            postIdNumberInforData(idNumber: cell.number_textField.text!)
        }
        else {
            WPProgressHUD.showInfor(status: "身份证号码格式错误")
        }
    }

    // MARK: - Request
    
    //验证身份信息
    func postIdNumberInforData(idNumber: String) {
        let parameter = ["idNumber" : WPPublicTool.base64EncodeString(string: idNumber)]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: wpUserApproveInforJudgeURL, parameters: parameter, success: { (result) in
            let state: NSInteger = result["state"] as! NSInteger
            if state == 1 {
                weakSelf?.navigationController?.pushViewController(WPPasswordPayController(), animated: true)
            }
            else {
                WPProgressHUD.showInfor(status: "身份信息验证失败")
            }
        }) { (error) in
            
        }
    }
    func getUserApproveData() {
        weak var weakSelf = self
        WPUserApproveModel.loadData(success: { (model) in
            weakSelf?.infor_model = model
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()
        }) { (error) in

        }
    }
    

}
