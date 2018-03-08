//
//  WPEShopPayResultSuccessController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/16.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopPayResultSuccessController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "支付结果"
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.register(UINib.init(nibName: "WPEShopPayResultSuccessCell", bundle: nil), forCellReuseIdentifier: WPEShopPayResultSuccessCellID)
        tableView.register(WPEShopPayResultSuccessCell.classForCoder(), forCellReuseIdentifier: WPEShopPayResultSuccessCellID)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: WPEShopPayResultSuccessCellID) as! WPEShopPayResultSuccessCell
        return cell
    }


}
