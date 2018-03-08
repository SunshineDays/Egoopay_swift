//
//  WPEShopMyEvaluateController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/11.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopMyEvaluateController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "评价晒图"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: .plain, target: self, action: #selector(self.confirmAction))
        
        if list_model.products.count > 0 {
            let array = WPEShopMyOrderListProductsModel.mj_objectArray(withKeyValuesArray: list_model.products)
            shop_array.addObjects(from: array as! [Any])
            for m in shop_array {
                let model: WPEShopMyOrderListProductsModel = m as! WPEShopMyOrderListProductsModel
                let contentModel = WPEShopMyEvalutateModel()
                contentModel.product_id = model.product_id
                content_array.add(contentModel)
            }
        }
        if detail_model.products.count > 0 {
            let array = WPEShopMyOrderDetailProductModel.mj_objectArray(withKeyValuesArray: detail_model.products)
            shop_array.addObjects(from: array as! [Any])
            for m in shop_array {
                let model: WPEShopMyOrderDetailProductModel = m as! WPEShopMyOrderDetailProductModel
                let contentModel = WPEShopMyEvalutateModel()
                contentModel.product_id = model.product_id
                content_array.add(contentModel)
            }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  订单列表模型 */
    var list_model = WPEShopMyOrderListModel()
    
    /**  订单详情模型 */
    var detail_model = WPEShopMyOrderDetailModel()
    
    
    /**  商品数组 */
    var shop_array = NSMutableArray()
    
    /**  存储用户选择和编写的内容 */
    let content_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPEShopMyEvalutateCell", bundle: nil), forCellReuseIdentifier: WPEShopMyEvalutateCellID)
        self.view.addSubview(tableView)
        return tableView
    }()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_model.products.count > 0 ? list_model.products.count : detail_model.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopMyEvalutateCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyEvalutateCellID, for: indexPath) as! WPEShopMyEvalutateCell
        if list_model.products.count > 0 {
            let model: WPEShopMyOrderListProductsModel = shop_array[indexPath.row] as! WPEShopMyOrderListProductsModel
            cell.list_model = model
        }
        if detail_model.products.count > 0 {
            let model: WPEShopMyOrderDetailProductModel = shop_array[indexPath.row] as! WPEShopMyOrderDetailProductModel
            cell.detail_model = model
        }
        let model: WPEShopMyEvalutateModel = content_array[indexPath.row] as! WPEShopMyEvalutateModel
        cell.stars = model
        weak var weakSelf = self
        //动态改变数据模型
        cell.eShopMyEvalutateCellType = {(stars, text) -> Void in
            model.stars = stars
            model.contentText = text
            weakSelf?.content_array.replaceObject(at: indexPath.row, with: model)
        }
        return cell
    }
    
    // MARK: - Action
    
    @objc func confirmAction() {
        let array = NSMutableArray()
        for m in content_array {
            let model: WPEShopMyEvalutateModel = m as! WPEShopMyEvalutateModel
            var dict = NSDictionary()
            dict = ["product_id" : String(format: "%d", model.product_id), "text" : model.contentText, "rating" : String(format: "%d", model.stars)]
            array.add(dict)
        }
        postEvaluateData(array: array)
    }
    
    // MARK: - Request
    
    @objc func postEvaluateData(array: NSMutableArray) {
        let parameter = ["order_info_id" : list_model.products.count > 0 ? list_model.order_info_id : detail_model.order_info_id,
                         "reviews" : WPPublicTool.jsonToString(any: ["reviews" : array])]
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPEShopEvalutateAddURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "提交评价成功")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
        
    }

}
