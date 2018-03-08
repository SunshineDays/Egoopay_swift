//
//  WPPasswordHintController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPasswordHintController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "修改支付密码"
        self.tableView.register(UINib.init(nibName: "WPPasswordHintCell", bundle: nil), forCellReuseIdentifier: WPPasswordHintCellID)
        self.tableView.separatorStyle = .none
//        NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
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
        let cell: WPPasswordHintCell = tableView.dequeueReusableCell(withIdentifier: WPPasswordHintCellID, for: indexPath) as! WPPasswordHintCell
        cell.no_button.addTarget(self, action: #selector(self.noAction), for: .touchUpInside)
        cell.yes_button.addTarget(self, action: #selector(self.yesAction), for: .touchUpInside)
        return cell
    }
    
    // MARK: - Action
    
    @objc func noAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func yesAction() {
        let parameter = ["phone" : WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!, "verType" : "2"]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPAuthCodeURL, parameters: parameter, success: { (result) in
            let vc = WPPasswordAuthCodeController()
            vc.authCodeType = 2
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }


}
