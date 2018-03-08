//
//  WPEShopPayOrderProductsController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopPayOrderProductsController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "商品清单"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "WPEShopMyOrderDetailCommodityCell", bundle: nil), forCellReuseIdentifier: WPEShopMyOrderDetailCommodityCellID)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  选择的商品数组 */
    var shop_array = NSMutableArray()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shop_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopMyOrderDetailCommodityCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyOrderDetailCommodityCellID, for: indexPath) as! WPEShopMyOrderDetailCommodityCell
        let model: WPEShopProductModel = shop_array[indexPath.row] as! WPEShopProductModel
        cell.model = model
        return cell
    }

}
