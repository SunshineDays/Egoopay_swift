//
//  WPEShopMyAddressController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyAddressController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的收货地址"
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
    
    /**  收货地址列表 */
    var list_array = NSMutableArray()
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: "WPEShopMyAddressCell", bundle: nil), forCellReuseIdentifier: WPEShopMyAddressCellID)
        tableView.separatorStyle = .none
        
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
        let cell: WPEShopMyAddressCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyAddressCellID, for: indexPath) as! WPEShopMyAddressCell
        
        let model = list_array[indexPath.section] as! WPEShopMyAddressModel
        cell.model = model
        
        cell.edit_button.tag = indexPath.section
        cell.edit_button.addTarget(self, action: #selector(self.editAction(_:)), for: .touchUpInside)
        cell.delete_button.tag = indexPath.section
        cell.delete_button.addTarget(self, action: #selector(self.deleteAction(_:)), for: .touchUpInside)
        
        cell.default_button.tag = indexPath.section
        cell.default_button.addTarget(self, action: #selector(self.defaultAction(_:)), for: .touchUpInside)
        
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
    
    
    // MARK: - Action
    
    @objc func addAction(_ button: UIButton) {
        self.navigationController?.pushViewController(WPEShopMyAddressEditController(), animated: true)
    }
    
    @objc func editAction(_ button: UIButton) {
        let vc = WPEShopMyAddressEditController()
        vc.isAddAddress = false
        let model = list_array[button.tag] as! WPEShopMyAddressModel
        vc.addressEdit_model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteAction(_ button: UIButton) {
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: "确定要删除此收货地址吗", confirmTitle: "删除", confirm: { (action) in
            let model = weakSelf?.list_array[button.tag] as! WPEShopMyAddressModel
            weakSelf?.postDeleteAddressData(addressID: model.address_id, section: button.tag)
        }) { (action) in
            
        }
    }
    
    @objc func defaultAction(_ button: UIButton) {
        let model = list_array[button.tag] as! WPEShopMyAddressModel
        postDefaultAddressData(addressID: model.address_id, section: button.tag)
        
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
    
    //设置默认收货地址
    func postDefaultAddressData(addressID: NSInteger, section: NSInteger) {
        let parameter = ["address_id" : addressID]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopAddressDefaultURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "设置成功")
            for i in 0 ..<  (weakSelf?.list_array.count)! {
                (weakSelf?.list_array[i] as! WPEShopMyAddressModel).is_default = section == i ? 1 : 0
            }
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    //删除收货地址
    func postDeleteAddressData(addressID: NSInteger, section: NSInteger) {
        let parameter = ["address_id" : addressID]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopAddressDeleteURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "删除成功")
            weakSelf?.list_array.removeObject(at: section)
            weakSelf?.tableView.deleteSections(IndexSet.init(integer: section), with: .automatic)
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
