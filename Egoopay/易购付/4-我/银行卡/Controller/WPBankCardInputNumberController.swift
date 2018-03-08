//
//  WPBankCardInputNumberController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBankCardInputNumberController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加银行卡"
        self.tableView.register(UINib.init(nibName: "WPBankCardInputNumberCell", bundle: nil), forCellReuseIdentifier: WPBankCardInputNumberCellID)
        self.tableView.separatorStyle = .none
        getUserApproveData()
        getSupportBankListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**  用户实名认证信息模型 */
    var approve_model = WPUserApproveModel()
    
    /**  支持银行卡列表 */
    let supportBankList_array = NSMutableArray()
    
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
        let cell: WPBankCardInputNumberCell = tableView.dequeueReusableCell(withIdentifier: WPBankCardInputNumberCellID, for: indexPath) as! WPBankCardInputNumberCell
        cell.model = approve_model
        cell.hint_button.addTarget(self, action: #selector(self.imageStateAction), for: .touchUpInside)
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        cell.support_button.addTarget(self, action: #selector(self.supportBankListAction), for: .touchUpInside)

        return cell
    }
    
    // MARK: - Action
    
    @objc func imageStateAction() {
        let alertController = UIAlertController.init(title: "持卡人说明", message: "为保证账户资金安全，只能绑定认证用户本人的银行卡", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "知道了", style: .cancel, handler: { (alertAction) in
            
        }))
        self.present(alertController, animated: true) {
            
        }
    }
    
    @objc func supportBankListAction() {
        let vc = WPSupportBankListController()
        vc.bankList_array = supportBankList_array
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextAction() {
        let cell: WPBankCardInputNumberCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPBankCardInputNumberCell
        let number = (cell.number_textField.text! as NSString).replacingOccurrences(of: " ", with: "")
        postJudgeCardType(number: number)
    }
    
    // MARK: - Request
    
    /**  获取实名认证信息 */
    func getUserApproveData() {
        weak var weakSelf = self
        WPUserApproveModel.loadData(success: { (model) in
            weakSelf?.approve_model = model
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()

        }) { (error) in
            
        }
    }
    
    func getSupportBankListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPSupportBankListURL, parameters: nil, success: { (result) in
            weakSelf?.supportBankList_array.addObjects(from: result["bankName"] as! [Any])
        }) { (error) in
            
        }
    }
    
    func postJudgeCardType(number: String) {
        
        weak var weakSelf = self
        WPLoadDataModel.postData(cardNumber: number) { (cardName, cardType) in
            if (weakSelf?.supportBankList_array.contains(cardName))! {
                let vc = WPBankCardInputInforController()
                vc.cardInfor_dic = ["cardNumber" : WPPublicTool.base64EncodeString(string: number), "cardType" : cardType, "bankName" : cardName, "bankZone" : ""]
                weakSelf?.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                WPProgressHUD.showInfor(status: "暂不支持该银行")
            }
        }
    }

}
