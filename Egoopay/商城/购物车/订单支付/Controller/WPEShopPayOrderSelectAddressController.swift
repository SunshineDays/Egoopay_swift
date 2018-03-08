//
//  WPEShopPayOrderSelectAddressController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/13.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

typealias WPEShopPayOrderSelectAddressType = (_ model: WPEShopMyAddressModel) -> Void

class WPEShopPayOrderSelectAddressController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择收货地址"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "管理", style: .plain, target: self, action: #selector(self.editAction))
        self.view.addSubview(add_button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddressListData()
    }
    
    var eShopPayOrderSelectAddressType: WPEShopPayOrderSelectAddressType?
    
    var list_array = NSMutableArray()
    
    var address_model = WPEShopMyAddressModel()
    
    lazy var add_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: kScreenHeight - 45 - WPNavigationHeight, width: kScreenWidth, height: 45))
        button.setTitle("新增收货地址", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeEShopColor()
        button.addTarget(self, action: #selector(self.addAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 45), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPEShopPayOrederSelectAddressCell", bundle: nil), forCellReuseIdentifier: WPEShopPayOrederSelectAddressCellID)
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
        let cell: WPEShopPayOrederSelectAddressCell = tableView.dequeueReusableCell(withIdentifier: WPEShopPayOrederSelectAddressCellID, for: indexPath) as! WPEShopPayOrederSelectAddressCell
        let model = list_array[indexPath.section] as! WPEShopMyAddressModel
        cell.model = model
        
        if model.address_id == address_model.address_id {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = list_array[indexPath.section] as! WPEShopMyAddressModel
        eShopPayOrderSelectAddressType?(model)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Action
    
    @objc func editAction() {
        self.navigationController?.pushViewController(WPEShopMyAddressController(), animated: true)
    }
    
    
    @objc func addAction(_ button: UIButton) {
        self.navigationController?.pushViewController(WPEShopMyAddressEditController(), animated: true)
    }
    
    // MARK: - Request
    
    //获取收货地址列表
    func getAddressListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopAddressListURL, parameters: nil, success: { (result) in
            weakSelf?.list_array.removeAllObjects()
            let array: NSMutableArray = WPEShopMyAddressModel.mj_objectArray(withKeyValuesArray: result["address"] as Any)
            weakSelf?.list_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_eShop_noResult_shop"), title: "您还没有收货地址，赶快去添加吧!")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            
        }
    }
}
