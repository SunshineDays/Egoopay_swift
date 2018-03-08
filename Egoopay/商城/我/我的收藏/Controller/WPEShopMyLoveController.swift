//
//  WPEShopMyLoveController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyLoveController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的收藏"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(self.editAction))
        self.view.addSubview(edit_view)
        
        getMyLoveData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** 是否是编辑状态 */
    var isEdit = false
    
    var data_array = NSMutableArray()
    
    lazy var edit_view: WPEShopEditFooterView = {
        let view = WPEShopEditFooterView.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - 55, width: kScreenWidth, height: 55))
        view.isHidden = true
        view.select_button.addTarget(self, action: #selector(self.allSelectedAction(_:)), for: .touchUpInside)
        view.edit_button.addTarget(self, action: #selector(self.cancelLoveAction), for: .touchUpInside)
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopMyLoveEditCell", bundle: nil), forCellReuseIdentifier: WPEShopMyLoveEditCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    
    // MARK: - UITableViewDataSoure
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopMyLoveEditCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyLoveEditCellID, for: indexPath) as! WPEShopMyLoveEditCell
        let model = data_array[indexPath.row] as! WPEShopProductModel
        cell.model = model
        cell.isEdit = isEdit
        cell.select_button.tag = indexPath.row
        cell.select_button.addTarget(self, action: #selector(self.selectedAction(_:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WPEShopShopDetailController()
        let model = data_array[indexPath.row] as! WPEShopProductModel
        vc.getShopDetailData(id: model.product_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action
    
    @objc func editAction() {
        isEdit = !isEdit
        self.navigationItem.rightBarButtonItem?.title = isEdit ? "完成" : "编辑"
        edit_view.isHidden = !isEdit
        tableView.frame.size.height = isEdit ? (kScreenHeight - WPNavigationHeight - 55) : (kScreenHeight - WPNavigationHeight)
        tableView.reloadData()
    }
    
    @objc func selectedAction(_ button: UIButton) {
        WPInterfaceTool.eShopSelectedOne(button: button, array: data_array, allButton: edit_view.select_button)
    }
    
    @objc func allSelectedAction(_ button: UIButton) {
        WPInterfaceTool.eShopSelectedAll(array: data_array, allButon: button, tableView: tableView)
    }
    
    @objc func cancelLoveAction() {
        let indexPathArray = NSMutableArray()
        let removeArray = NSMutableArray()
        for i in 0 ..< data_array.count {
            let model: WPEShopProductModel = data_array[i] as! WPEShopProductModel
            if model.isSelected == 1 {
                let indexPath = IndexPath.init(row: i, section: 0)
                indexPathArray.add(indexPath)
                removeArray.add(data_array[i])
            }
        }
        if removeArray.count == 0 {
            WPProgressHUD.showInfor(status: "请选择商品")
        }
        else {
            postDeleteLoveData(array: removeArray, indexPathArray: indexPathArray)
        }
    }

    
    func changeViewConfig(array: NSMutableArray) {
        edit_view.select_button.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        edit_view.isHidden = true
        if array.count > 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(self.editAction))
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
        isEdit = false
    }
    
    // MARK: - Request
    
    //获取收藏列表
    func getMyLoveData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopLoveListURL, parameters: nil, success: { (result) in
            weakSelf?.data_array.removeAllObjects()
            let array: NSMutableArray = WPEShopProductModel.mj_objectArray(withKeyValuesArray: result["wishlists"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_eShop_noResult_shop"), title: "您还没有收藏的商品")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
            weakSelf?.changeViewConfig(array: (weakSelf?.data_array)!)
        }) { (error) in
            
        }
    }
    
    //删除收藏
    func postDeleteLoveData(array: NSMutableArray, indexPathArray: NSMutableArray) {
        let product_ids = NSMutableArray()
        for i in 0 ..< array.count {
            let productID = (array[i] as! WPEShopProductModel).product_id
            product_ids.add(productID)
        }
        let parameter = ["product_ids" : product_ids]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPEShopLoveDeleteURL, parameters: parameter, success: { (result) in
            weakSelf?.data_array.removeObjects(in: array as! [Any])
            if weakSelf?.data_array.count != 0 {
                weakSelf?.tableView.deleteRows(at: indexPathArray as! [IndexPath], with: .automatic)
                weakSelf?.tableView.reloadData()
            }
            else {
                weakSelf?.getMyLoveData()
            }
            weakSelf?.changeViewConfig(array: (weakSelf?.data_array)!)
        }) { (error) in
            
        }
    }
    
    
}
