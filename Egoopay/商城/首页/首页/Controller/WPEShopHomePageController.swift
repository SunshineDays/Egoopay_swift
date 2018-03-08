//
//  WPEShopHomePageController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopHomePageController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addSubview(searchTitle_view)
        
        getAllShopData(page: 1)
        getScrollViewData()
        getRegisterEShopData()
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.getAllShopData(page: 1)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page += 1
            weakSelf?.getAllShopData(page: (weakSelf?.page)!)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UICollectionView
    
    var page = 1
    
    /**  热销商品 */
    let list_array = NSMutableArray()

    
    lazy var searchTitle_view: WPSearchTitleView = {
        let view = WPSearchTitleView()
        view.goBack_button.addTarget(self, action: #selector(self.goBackAction), for: .touchUpInside)
        return view
    }()
    
    lazy var header_view: WPEShopHomePageHeaderView = {
        let view = WPEShopHomePageHeaderView()
        return view
    }()
    
    // MARK: - UITableView
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPTabBarHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableHeaderView = self.header_view
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        tableView.register(UINib.init(nibName: "WPEShopHomePageCell", bundle: nil), forCellReuseIdentifier: WPEShopHomePageCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    
    // MARK: - UITableViewDataSoure
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopHomePageCell = tableView.dequeueReusableCell(withIdentifier: WPEShopHomePageCellID, for: indexPath) as! WPEShopHomePageCell
        let model: WPEShopProductModel = list_array[indexPath.row] as! WPEShopProductModel
        cell.model = model
        cell.cart_button.tag = indexPath.row
        cell.cart_button.addTarget(self, action: #selector(self.addToCartData(_:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WPEShopShopDetailController()
        let model = list_array[indexPath.row] as! WPEShopProductModel
        vc.getShopDetailData(id: model.product_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UIScrollerViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > 50 {
            searchTitle_view.backgroundColor = UIColor.white
            searchTitle_view.searchBar.backgroundColor = UIColor.lineColor()
            searchTitle_view.line_view.backgroundColor = UIColor.lineColor()
        }
        else {
            searchTitle_view.backgroundColor = UIColor.clear
            searchTitle_view.searchBar.backgroundColor = UIColor.colorConvert(colorString: "ffffff", alpha: 0.2)
            searchTitle_view.line_view.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Action
    @objc func goBackAction() {
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: nil)
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = kCATransitionMoveIn
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
        UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
        UserDefaults.standard.synchronize()
    }
    
    /**  加入购物车 */
    @objc func addToCartData(_ button: UIButton) {
        let model: WPEShopProductModel = list_array[button.tag] as! WPEShopProductModel
        WPLoadDataModel.postEShopAddToCart(model: model)
    }
    
    
    // MARK: - Request
    
    /**  获取全部 */
    func getAllShopData(page: NSInteger) {
        weak var weakSelf = self
        let parameter = ["start" : page]
        WPDataTool.GETRequest(url: WPEShopAllURL, parameters: parameter, success: { (result) in
            if page == 1 {
                weakSelf?.list_array.removeAllObjects()
            }
            let array: NSMutableArray = WPEShopProductModel.mj_objectArray(withKeyValuesArray: result["products"] as Any)
            weakSelf?.list_array.addObjects(from: array as! [Any])
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
        }
    }
    
    /** 获取ScrollView数据 */
    func getScrollViewData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopBannerURL, parameters: nil, success: { (result) in
            let resultArray = NSMutableArray()
            resultArray.addObjects(from: WPEShopBannerModel.mj_objectArray(withKeyValuesArray: result["banner"]) as! [Any])
            let imageArray = NSMutableArray()
            for i in 0 ..< resultArray.count {
                let model: WPEShopBannerModel = resultArray[i] as! WPEShopBannerModel
                imageArray.add(model.image)
            }
            weakSelf?.header_view.initScrollViewImageArray(array: imageArray)
        }) { (error) in
            
        }
    }
    
    /**  登录/注册商城 */
    func getRegisterEShopData() {
        WPDataTool.GETRequest(url: WPEShopRegisterURL, parameters: nil, success: { (result) in
            
        }) { (error) in
            
        }
    }
    
    
}
