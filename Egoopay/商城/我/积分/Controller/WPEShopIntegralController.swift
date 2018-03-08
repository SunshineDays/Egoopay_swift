//
//  WPEShopIntegralController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/15.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopIntegralController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的积分"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "userHelp"), style: .plain, target: self, action: #selector(self.userHelpAction))
        self.view.addSubview(header_view)
        getMyLoveData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**  0:积分明细 1:已兑换商品 */
    var selectedNumber = 0
    
    /** 是否是编辑状态 */
    var isEdit = false
    
    var data_array = NSMutableArray()
    
    lazy var header_view: WPEShopMyOrderHeaderView = {
        let view = WPEShopMyOrderHeaderView()
        view.initInfor(showNumber: 2, selectedNumber: selectedNumber, titleArray: ["积分明细", "已兑换商品"])
        view.collectionView.delegate = self
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.header_view.frame.maxY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - self.header_view.frame.size.height), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopIntegralCell", bundle: nil), forCellReuseIdentifier: WPEShopIntegralCellID)
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
        if selectedNumber == 0 {
            let cell: WPEShopIntegralCell = tableView.dequeueReusableCell(withIdentifier: WPEShopIntegralCellID, for: indexPath) as! WPEShopIntegralCell
            
            return cell
        }
        else {
            let cell: WPEShopMyLoveEditCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyLoveEditCellID, for: indexPath) as! WPEShopMyLoveEditCell
            
            return cell
        }
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        header_view.viewColors.removeAllObjects()
        for i in 0 ..< header_view.title_array.count {
            header_view.viewColors.add(indexPath.row == i ? UIColor.themeEShopColor() : UIColor.clear)
        }
        header_view.collectionView.reloadData()
        selectedNumber = indexPath.row
        tableView.reloadData()
    }
    
    
    // MARK: - Action
    
    @objc func userHelpAction() {
        
    }
    
    // MARK: - Request
    
    func getMyLoveData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopAllURL, parameters: nil, success: { (result) in
            let array: NSMutableArray = WPEShopProductModel.mj_objectArray(withKeyValuesArray: result["products"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_eShop_noResult_shop"), title: "您还没有收藏的商品")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            
        }
    }
    
    
}
