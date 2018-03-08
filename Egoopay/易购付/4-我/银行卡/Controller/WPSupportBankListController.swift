//
//  WPSupportBankListController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/14.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSupportBankListController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "支持银行卡类型"
        self.tableView.separatorStyle = .singleLine
        self.tableView.register(UINib.init(nibName: "WPSupportBankListCell", bundle: nil), forCellReuseIdentifier: WPSupportBankListCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**  支持的银行卡列表 */
    var bankList_array = NSMutableArray()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bankList_array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPSupportBankListCell = tableView.dequeueReusableCell(withIdentifier: WPSupportBankListCellID, for: indexPath) as! WPSupportBankListCell
        cell.bankName_label.text = bankList_array[indexPath.row] as? String
        return cell
    }

}
