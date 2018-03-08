//
//  WPEShopMyOrderController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyOrderController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的订单"
        self.view.addSubview(header_view)
        
        changeStatus()
        
        getOrderListData(status: status, page: page)
        
        weak var weakSelf = self
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page = (weakSelf?.page)! + 1
            weakSelf?.getOrderListData(status: (weakSelf?.status)!, page: (weakSelf?.page)!)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /**  页码 */
    var page = 1
    
    /**  订单列表数组 */
    let list_array = NSMutableArray()
    
    /**  选择哪一行 */
    var selectedNumber = 0
    
    /**  不同状态对应的ID */
    var status = String()
    
    lazy var header_view: WPEShopMyOrderHeaderView = {
        let view = WPEShopMyOrderHeaderView()
        view.initInfor(showNumber: 5, selectedNumber: selectedNumber, titleArray: ["全部", "待付款", "待发货", "待收货", "待评价"])
        view.collectionView.delegate = self
        return view
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.header_view.frame.maxY, width: kScreenWidth, height: kScreenHeight - self.header_view.frame.maxY - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopMyOrderCell", bundle: nil), forCellReuseIdentifier: WPEShopMyOrderCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopMyOrderCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyOrderCellID, for: indexPath) as! WPEShopMyOrderCell
        let model: WPEShopMyOrderListModel = list_array[indexPath.section] as! WPEShopMyOrderListModel
        cell.model = model
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToOrderDetail(row: indexPath.section)
    }

    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.header_view.collectionView:
            header_view.viewColors.removeAllObjects()
            for i in 0 ..< header_view.title_array.count {
                header_view.viewColors.add(indexPath.row == i ? UIColor.themeEShopColor() : UIColor.clear)
            }
            header_view.collectionView.reloadData()
            selectedNumber = indexPath.row
            changeStatus()
            page = 1
            getOrderListData(status: status, page: page)
        default:
            goToOrderDetail(row: collectionView.tag)
        }
        
    }
    
    
    // MARK: - Action
    
    func changeStatus() {
        switch selectedNumber {
        case 0: //全部
            status = ""
        case 1: //待付款
            status = "4"
        case 2: //待发货
            status = "15"
        case 3: //待收货
            status = "3"
        case 4: //待评价
            status = "6"
        default:
            break
        }
    }
    
    //跳转到订单详情
    func goToOrderDetail(row: NSInteger) {
        let model: WPEShopMyOrderListModel = list_array[row] as! WPEShopMyOrderListModel
        let vc = WPEShopMyOrderDetailController()
        vc.detail_model.order_info_id = model.order_info_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Request
    
    //获取订单列表
    func getOrderListData(status: String, page: NSInteger) {
        let parameter = ["order_status_id" : status,
                         "start" : page] as [String : Any]
        print(parameter)
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.GETRequest(url: WPEShopOrderListURL, parameters: parameter, success: { (result) in
            WPProgressHUD.dismiss()
            if page == 1 {
                weakSelf?.list_array.removeAllObjects()
            }
            let array: NSMutableArray = WPEShopMyOrderListModel.mj_objectArray(withKeyValuesArray: result["orders"])
            weakSelf?.list_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_eShop_noResult_shop"), title: "您还没有相关订单")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            weakSelf?.page = (weakSelf?.page)! > 1 ? (weakSelf?.page)! - 1 : 1
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
    
    

}
