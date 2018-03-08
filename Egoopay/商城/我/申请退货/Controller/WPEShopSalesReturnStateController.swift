//
//  WPEShopSalesReturnStateController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/15.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopSalesReturnStateController: WPBaseViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "申请退货"
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopSalesReturnRecordCell", bundle: nil), forCellReuseIdentifier: WPEShopSalesReturnRecordCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopSalesReturnRecordCell = tableView.dequeueReusableCell(withIdentifier: WPEShopSalesReturnRecordCellID, for: indexPath) as! WPEShopSalesReturnRecordCell
        return cell
        
    }
    
    
}
