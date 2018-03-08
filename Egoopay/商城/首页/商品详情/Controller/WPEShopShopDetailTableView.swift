//
//  WPEShopShopDetailTableView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/2.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopShopDetailTableView: UIView, UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var eval_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 50), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopShopDetaiEvaluateCell", bundle: nil), forCellReuseIdentifier: WPEShopShopDetaiEvaluateCellID)
        self.addSubview(tableView)
        return tableView
    }()


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eval_array.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopShopDetaiEvaluateCell = tableView.dequeueReusableCell(withIdentifier: WPEShopShopDetaiEvaluateCellID, for: indexPath) as! WPEShopShopDetaiEvaluateCell
        cell.model = eval_array[indexPath.row] as! WPEShopShopDetailEvaluateModel
        return cell
    }
    
}
