//
//  WPUserApproveNumberController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserApproveNumberController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "实名认证"
        self.tableView.register(UINib.init(nibName: "WPUserApproveNumberCell", bundle: nil), forCellReuseIdentifier: WPUserApproveNumberCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPUserApproveNumberCell = tableView.dequeueReusableCell(withIdentifier: WPUserApproveNumberCellID, for: indexPath) as! WPUserApproveNumberCell
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return cell
    }
 

    // MARK: - Action
    
    @objc func nextAction() {
        let cell: WPUserApproveNumberCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPUserApproveNumberCell
        if !WPJudgeTool.validate(idCard: cell.number_textField.text!) {
            WPProgressHUD.showError(status: "身份证号码格式错误")
        }
        else {
            postIDCardInforToValidate(name: cell.name_textField.text!, number: cell.number_textField.text!)
        }
    }
    
    
    // MARK: - Request
    
    /**  判断名字和身份证号码是否一致 */
    func postIDCardInforToValidate(name: String, number: String) {
        weak var weakSelf = self
        let parameter = ["idCard" : WPPublicTool.base64EncodeString(string: number), "fullName" : name]
        WPDataTool.POSTRequest(baseUrl: WPBaseURL, url: WPValiteIDCardInforURL, parameters: parameter, success: { (success) in
            let vc = WPUserApprovePhotoController()
            vc.infor_dic.addEntries(from: ["identityCard" : WPPublicTool.base64EncodeString(string: number), "fullName" : name])
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }
    
}
