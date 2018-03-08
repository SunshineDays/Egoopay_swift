
//
//  WPMessageController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPMessageController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "消息"
        getMessageData()
        
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.getMessageData()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page_int = (weakSelf?.page_int)! + 1
            weakSelf?.getMessageData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var page_int = 1
    
    /** 消息列表数组 */
    var data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPTitleTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleTitleCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data_array.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPTitleTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleTitleCellID, for: indexPath) as! WPTitleTitleCell
        cell.model = self.data_array[indexPath.row] as! WPMessageSystemModel
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: WPMessageSystemModel = self.data_array[indexPath.row] as! WPMessageSystemModel
        let vc = WPMessageDetailController()
        vc.message_model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Request
    
    /** 获取消息数据 */
    func getMessageData() {
        weak var weakSelf = self
        
        
        WPDataTool.GETRequest(url: WPMessageURL, parameters: ["curPage" : page_int],  success: { (result) in
            if weakSelf?.page_int == 1 {
                weakSelf?.data_array.removeAllObjects()
            }
            let array: NSMutableArray = WPMessageSystemModel.mj_objectArray(withKeyValuesArray: result["msgList"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_noMessage"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)

        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }

}
