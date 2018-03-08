//
//  WPEShopMyOrderDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyOrderDetailController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "订单详情"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrderDetailData(orderId: detail_model.order_info_id)
    }
    
    
    /**  订单详情模型 */
    var detail_model = WPEShopMyOrderDetailModel()
    
    /**  订单商品数组 */
    let list_array = NSMutableArray()
    
    lazy var footer_view: WPEShopMyOrderDetailFooterView = {
        let view = WPEShopMyOrderDetailFooterView.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - 51, width: kScreenWidth, height: 51))
        self.view.addSubview(view)
        return view
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 51), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopMyOrderDetailAddressCell", bundle: nil), forCellReuseIdentifier: WPEShopMyOrderDetailAddressCellID)
        tableView.register(UINib.init(nibName: "WPEShopMyOrderDetailCommodityCell", bundle: nil), forCellReuseIdentifier: WPEShopMyOrderDetailCommodityCellID)
        tableView.register(UINib.init(nibName: "WPEShopMyOrderDetailOrderInforCell", bundle: nil), forCellReuseIdentifier: WPEShopMyOrderDetailOrderInforCellID)
        self.view.addSubview(tableView)
        return tableView
    }()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? list_array.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPEShopMyOrderDetailAddressCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyOrderDetailAddressCellID, for: indexPath) as! WPEShopMyOrderDetailAddressCell
            cell.model = detail_model
            return cell
        case 1:
            let cell: WPEShopMyOrderDetailCommodityCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyOrderDetailCommodityCellID, for: indexPath) as! WPEShopMyOrderDetailCommodityCell
            let model: WPEShopMyOrderDetailProductModel = list_array[indexPath.row] as! WPEShopMyOrderDetailProductModel
            cell.detailModel = model
            return cell
        default:
            let cell: WPEShopMyOrderDetailOrderInforCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyOrderDetailOrderInforCellID, for: indexPath) as! WPEShopMyOrderDetailOrderInforCell
            cell.model = detail_model
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = WPEShopShopDetailController()
            let model: WPEShopMyOrderDetailProductModel = list_array[indexPath.row] as! WPEShopMyOrderDetailProductModel
            vc.getShopDetailData(id: model.product_id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Request
    
    //获取订单详情
    func getOrderDetailData(orderId: String) {
        let parameter = ["order_info_id" : orderId]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEshopOrderDetailURL, parameters: parameter, success: { (result) in
            weakSelf?.list_array.removeAllObjects()
            weakSelf?.detail_model = WPEShopMyOrderDetailModel.mj_object(withKeyValues: result["orders"])
            weakSelf?.list_array.addObjects(from: WPEShopMyOrderDetailProductModel.mj_objectArray(withKeyValuesArray: weakSelf?.detail_model.products) as! [Any])
            weakSelf?.tableView.reloadData()
            weakSelf?.footer_view.detail_model = weakSelf?.detail_model
        }) { (error) in
            
        }
    }
    
    
    
}
