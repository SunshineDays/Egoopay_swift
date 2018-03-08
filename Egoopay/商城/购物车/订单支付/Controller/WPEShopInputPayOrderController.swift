//
//  WPEShopInputPayOrderController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

typealias WPEShopInputPayOrderType = (_ isRefresh: Bool) -> Void

class WPEShopInputPayOrderController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "填写订单"
        tableView.reloadData()
        self.view.addSubview(footer_view)
        getAddressListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eShopInputPayOrderType!(false)
    }
    
    /**  返回是否刷新购物车数据 */
    var eShopInputPayOrderType: WPEShopInputPayOrderType?
    
    /**  选择的商品数组 */
    var select_array = NSMutableArray()
    
    /**  地址模型 */
    var address_model = WPEShopMyAddressModel()
    
    /**  总价 */
    var totalMoney = Double()
    
    /**  选择的数量 */
    var totalNumber = NSInteger()
    
    lazy var footer_view: WPEShopOrderFooterView = {
        let view = WPEShopOrderFooterView.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - 55, width: kScreenWidth, height: 55))
        view.money_label.text = "需付款:￥" + String(format: "%.2f", totalMoney)
        view.pay_button.addTarget(self, action: #selector(self.payAction), for: .touchUpInside)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 55), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: "WPEShopInputPayOrederCell", bundle: nil), forCellReuseIdentifier: WPEShopInputPayOrederCellID)
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
        let cell: WPEShopInputPayOrederCell = tableView.dequeueReusableCell(withIdentifier: WPEShopInputPayOrederCellID, for: indexPath) as! WPEShopInputPayOrederCell
        cell.collectionView.delegate = self
        cell.shopArray = select_array
        cell.number = totalNumber
        cell.totalMoney = totalMoney
        cell.select_button.addTarget(self, action: #selector(self.selectAddressAction), for: .touchUpInside)
        cell.addressModel = address_model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WPEShopPayOrderProductsController()
        vc.shop_array = select_array
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action
    
    @objc func selectAddressAction() {
        let vc = WPEShopPayOrderSelectAddressController()
        vc.address_model = address_model
        weak var weakSelf = self
        vc.eShopPayOrderSelectAddressType = {(model) -> Void in
            weakSelf?.address_model = model
            weakSelf?.tableView.reloadData()
        }
        vc.list_array = list_array
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func payAction() {
        let cell: WPEShopInputPayOrederCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEShopInputPayOrederCell
        if address_model.firstname.count > 0 {
            postPayOrderCreateData(comment: cell.message_textField.text ?? "")
        }
        else {
            WPProgressHUD.showInfor(status: "请选择收货地址")
        }
    }
    
    
    // MARK: - Request
    
    let list_array = NSMutableArray()
    
    //获取收货地址列表
    func getAddressListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopAddressListURL, parameters: nil, success: { (result) in
            let array: NSMutableArray = WPEShopMyAddressModel.mj_objectArray(withKeyValuesArray: result["address"] as Any)
            weakSelf?.list_array.addObjects(from: array as! [Any])
            if weakSelf?.list_array != nil {
                if (weakSelf?.list_array.count)! > 0 {
                    weakSelf?.getDefaultAddressModel(array: (weakSelf?.list_array)!)
                }
            }
        }) { (error) in
            
        }
    }
    
    func getDefaultAddressModel(array: NSMutableArray) {
        for i in 0 ..< array.count {
            let model: WPEShopMyAddressModel = array[i] as! WPEShopMyAddressModel
            if model.is_default == 1 {
                self.address_model = model
                break
            }
            else {
                self.address_model = model
            }
        }
        tableView.reloadData()
    }
    
    
    /**  生成订单 */
    func postPayOrderCreateData(comment: String) {
        let cart_ids = NSMutableArray()
        for i in select_array {
            let model = i as! WPEShopProductModel
            cart_ids.add(model.cart_id)
        }
        let data = try?JSONSerialization.data(withJSONObject: cart_ids, options: .prettyPrinted)
        let json = String.init(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let parameter = ["shipping_method" : "快递配送",
                         "comment" : comment,
                         "address_id" : address_model.address_id,
                         "payment_method" : "",
                         "cart_ids" : json ?? "",
                         "total" : totalMoney] as [String : Any]
        weak var weakSelf = self
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPEShopOrderCreateURL, parameters: parameter, success: { (result) in
            let vc = WPEShopPayOrderWithAppController()
            vc.order_model = WPEShopPayOrderDetailModel.mj_object(withKeyValues: result)
            vc.totalMoney = (weakSelf?.totalMoney)!
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            
        }
    }
    
}
