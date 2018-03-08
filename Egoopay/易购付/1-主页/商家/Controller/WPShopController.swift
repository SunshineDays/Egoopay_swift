//
//  WPShopController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/2.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShopController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "商家"
        getShopListData()
        getScrollViewData()
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.cityName = "全部商家"
            weakSelf?.postShopListData(cityName: "", page: 1)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.pageCount += 1
            weakSelf?.postShopListData(cityName: (weakSelf?.cityName)!, page: (weakSelf?.pageCount)!)
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var pageCount = 1
    
    var cityName = "全部商家"
    
    var data_array = NSMutableArray()
    
    lazy var header_view: WPShopHeaderView = {
        let view = WPShopHeaderView()
        view.searchBar.delegate = self
        view.city_button.addTarget(self, action: #selector(self.shopCitySelect), for: .touchUpInside)
        return view
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = self.header_view
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPShopCell", bundle: nil), forCellReuseIdentifier: WPShopCellID)
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
        let cell: WPShopCell = tableView.dequeueReusableCell(withIdentifier: WPShopCellID, for: indexPath) as! WPShopCell
        cell.model = data_array[indexPath.row] as! WPShopDetailModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let imageView = UIImageView.init(frame: CGRect.init(x: WPLeftMargin, y: 10, width: 25, height: 25))
        imageView.image = #imageLiteral(resourceName: "icon_shopshop")
        view.addSubview(imageView)
        let label = UILabel.init(frame: CGRect.init(x: imageView.frame.maxX + 10, y: 10, width: kScreenWidth - 80, height: 25))
        label.text = cityName
        label.textColor = UIColor.themeColor()
        label.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: WPShopDetailModel = data_array[indexPath.row] as! WPShopDetailModel
        let vc = WPShopDetailController()
        vc.navigationItem.title = model.shopName
        vc.shopModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = WPShopSearchController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action
    @objc func shopCitySelect() {
        let vc = WPSelectShopCityController()
        weak var weakSelf = self
        vc.selectedShopCityType = {(cityName) -> Void in
            weakSelf?.cityName = cityName
            weakSelf?.postShopListData(cityName: cityName, page: (weakSelf?.pageCount)!)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Request
    
    /**  获取商家列表 */
    func getShopListData() {
        weak var weakSelf = self
        let parameter = ["categoryId" : "",
                         "city" : "",
                         "curPage" : 1] as [String : Any]
        
        WPDataTool.GETRequest(url: WPShowMerShopsURL, parameters: parameter, success: { (result) in
            let array: NSMutableArray = WPShopDetailModel.mj_objectArray(withKeyValuesArray: result["shopList"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: nil, title: "暂无商家")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
            
        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
    
    func postShopListData(cityName: String, page: NSInteger) {
        weak var weakSelf = self
        let parameter = ["categoryId" : "",
                         "city" : cityName,
                         "curPage" : page] as [String : Any]

        WPDataTool.POSTRequest(url: WPShowMerShopsURL, parameters: parameter, success: { (result) in
            if page == 1 {
                weakSelf?.data_array.removeAllObjects()
            }
            let array: NSMutableArray = WPShopDetailModel.mj_objectArray(withKeyValuesArray: result["shopList"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: nil, title: "没有符合条件的商家")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
            
        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
    
    /** 获取ScrollView数据 */
    func getScrollViewData() {
        weak var weakSelf = self
        WPLoadDataModel.getData(bannerCode: "2") { (dataArray) in
            weakSelf?.header_view.scrollView.imageURLStringsGroup = dataArray
            weakSelf?.header_view.scrollView.reloadInputViews()
        }
    }
}
