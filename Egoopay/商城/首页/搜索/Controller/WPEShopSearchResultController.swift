//
//  WPEShopSearchResultController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/10.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopSearchResultController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(search_view)
        self.view.addSubview(header_view)

        let searchHistoryArray: Array = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_searchHistory)
        search = searchHistoryArray.last as! String
        postSearchResultData(search: search, page: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    var search = String()
    
    let data_array = NSMutableArray()
    
    lazy var search_view: WPSearchTitleView = {
        let view = WPSearchTitleView()
        view.backgroundColor = UIColor.white
        view.searchBar.text = self.search
        view.searchBar.backgroundColor = UIColor.lineColor()
        view.line_view.backgroundColor = UIColor.lineColor()
        view.isPush = false
        view.goBack_button.addTarget(self, action: #selector(self.goBackAction), for: .touchUpInside)
        weak var weakSelf = self
        view.searchTitleType = {(search) -> Void in
            weakSelf?.postSearchResultData(search: search, page: 1)
        }
        return view
    }()

    lazy var header_view: WPEShopSearchResultHeaderView = {
       let view = WPEShopSearchResultHeaderView.init(frame: CGRect.init(x: 0, y: WPNavigationHeight, width: kScreenWidth, height: 40))
        view.collectionView.delegate = self
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.header_view.frame.maxY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - self.header_view.frame.size.height), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopHomePageCell", bundle: nil), forCellReuseIdentifier: WPEShopHomePageCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopHomePageCell = tableView.dequeueReusableCell(withIdentifier: WPEShopHomePageCellID, for: indexPath) as! WPEShopHomePageCell
        let model: WPEShopProductModel = data_array[indexPath.row] as! WPEShopProductModel
        cell.model = model
        cell.cart_button.tag = indexPath.row
        cell.cart_button.addTarget(self, action: #selector(self.addToCartData(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data_array[indexPath.row] as! WPEShopProductModel
        let vc = WPEShopShopDetailController()
        vc.getShopDetailData(id: model.product_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        header_view.color_array.removeAllObjects()
        let image: UIImage = header_view.image_array[indexPath.row] as! UIImage
        header_view.image_array.removeAllObjects()
        for i in 0 ..< header_view.title_array.count {
            header_view.color_array.add(indexPath.row == i ? UIColor.themeEShopColor() : UIColor.black)
            header_view.image_array.add(indexPath.row == i ? (image == #imageLiteral(resourceName: "icon_eShop_search_default") ? #imageLiteral(resourceName: "icon_eShop_search_up") : (image == #imageLiteral(resourceName: "icon_eShop_search_up") ? #imageLiteral(resourceName: "icon_eShop_search_down") : #imageLiteral(resourceName: "icon_eShop_search_up"))) : #imageLiteral(resourceName: "icon_eShop_search_default"))
        }
        header_view.collectionView.reloadData()
    }
    
    // MARK: - Action
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToCartData(_ button: UIButton) {
        let model: WPEShopProductModel = data_array[button.tag] as! WPEShopProductModel
        WPLoadDataModel.postEShopAddToCart(model: model)
    }
    
    // MARK: - Request
    
    func postSearchResultData(search: String, page: NSInteger) {
        let parameter = ["search" : search]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading() 
        WPDataTool.POSTRequest(url: WPEShopSearchURL, parameters: parameter, success: { (result) in
            weakSelf?.data_array.removeAllObjects()
            let array: NSMutableArray = WPEShopProductModel.mj_objectArray(withKeyValuesArray: result["products"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_eShop_noResult_shop"), title: "没有符合条件的商品")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
            
        }) { (error) in
            
        }
    }
    

}
