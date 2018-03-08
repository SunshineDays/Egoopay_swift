//
//  WPShopSearchController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShopSearchController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(searchBar)
        self.view.addSubview(cancel_button)
        
        weak var weakSelf = self
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.pageCount += 1
            weakSelf?.postShopListData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = false
    }
    
    var data_array = NSMutableArray()

    var pageCount = 1
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 5, y: WPStatusBarHeight + 5, width: kScreenWidth - 60, height: 34))
        searchBar.delegate = self
        searchBar.placeholder = "搜索商家"
        searchBar.subviews[0].subviews[0].removeFromSuperview()
        searchBar.layer.borderColor = UIColor.themeColor().cgColor
        searchBar.layer.borderWidth = WPLineHeight
        searchBar.layer.cornerRadius = WPCornerRadius
        searchBar.becomeFirstResponder()
        return searchBar
    }()
    
    lazy var cancel_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: self.searchBar.frame.maxX + 5, y: WPStatusBarHeight + 5, width: 45, height: 34))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.themeColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPNavigationHeight, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: WPShopDetailModel = data_array[indexPath.row] as! WPShopDetailModel
        let vc = WPShopDetailController()
        vc.navigationItem.title = model.shopName
        //        vc.shopID = model.shop_id
        vc.shopModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            postShopListData()
        }
    }
    
    // MARK: -Action
    
    @objc func cancelAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
//        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Request
    
    /**  获取商家列表 */
    func postShopListData() {
        weak var weakSelf = self
        let parameter = ["shopName" : searchBar.text ?? "",
                         "curPage" : pageCount] as [String : Any]
        
        WPDataTool.POSTRequest(url: WPShowMerShopsURL, parameters: parameter, success: { (result) in
            weakSelf?.searchBar.endEditing(true)
            weakSelf?.data_array.removeAllObjects()
            let array: NSMutableArray = WPShopDetailModel.mj_objectArray(withKeyValuesArray: result["shopList"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_noShop"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }

}
