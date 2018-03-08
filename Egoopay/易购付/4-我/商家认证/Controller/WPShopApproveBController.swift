//
//  WPShopApproveBController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPShopApproveBController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.title = "商家认证"
        tableView.register(UINib.init(nibName: "WPShopInforInputBCell", bundle: nil), forCellReuseIdentifier: WPShopInforInputBCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  存储用户输入的信息的字典 */
    let infor_dic = NSMutableDictionary()

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
        let cell: WPShopInforInputBCell = tableView.dequeueReusableCell(withIdentifier: WPShopInforInputBCellID, for: indexPath) as! WPShopInforInputBCell
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    // MARK: - Action
    
    @objc func nextAction() {
        let cell: WPShopInforInputBCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopInforInputBCell
        if !WPJudgeTool.validate(idCard: cell.idCard_textField.text!) {
            WPProgressHUD.showInfor(status: "身份证号码格式错误")
        }
        else if !WPJudgeTool.validate(email: cell.email_textField.text!) {
            WPProgressHUD.showInfor(status: "企业邮箱格式错误")
        }
        else {
            postIDCardInforToValidate(name: cell.fullName_textField.text!, number: cell.idCard_textField.text!)
        }
    }
    
    
    // MARK: - Request
    
    /**  判断名字和身份证号码是否一致 */
    func postIDCardInforToValidate(name: String, number: String) {
        let parameter = ["idCard" : WPPublicTool.base64EncodeString(string: number),
                         "fullName" : name]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPValiteIDCardInforURL, parameters: parameter, success: { (success) in
            let cell: WPShopInforInputBCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopInforInputBCell
            let dic = ["busilicenceNo" : WPPublicTool.base64EncodeString(string: cell.shopNumber_textField.text!),
                       "leaderName" : cell.fullName_textField.text!,
                       "leaderCardId" : WPPublicTool.base64EncodeString(string: cell.idCard_textField.text!),
                       "corporateEmail" : cell.email_textField.text!]
            weakSelf?.infor_dic.addEntries(from: dic)
            let vc = WPShopApproveCController()
            vc.infor_dic.addEntries(from: weakSelf?.infor_dic as! [AnyHashable : Any])
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }

}
