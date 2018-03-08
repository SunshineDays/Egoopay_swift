//
//  WPBillMessageController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBillMessageCellID : String = "WPBillMessageCell"

class WPBillMessageController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "消息"
        self.view.backgroundColor = UIColor.tableViewColor()
        getBillMessageData()
        
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            if weakSelf?.data_array.count != 0 {
                weakSelf?.page_int = (weakSelf?.page_int)! + 1
            }
            weakSelf?.getBillMessageData()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WPNotificationSelectedMessageItem, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: WPNotificationSelectedMessageItem, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshData() {
        self.page_int = 1
        getBillMessageData()
    }
    
    
    var isRefresh = true
    
    var data_array = NSMutableArray()
    
    var page_int: Int = 1
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView (frame: CGRect(x: 6, y: WPTopY, width: kScreenWidth - 12, height: kScreenHeight - WPTabBarHeight - WPNavigationHeight), style:UITableViewStyle.grouped)
        tempTableView.backgroundColor = UIColor.clear
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableFooterView = UIView()

        tempTableView.register(UINib.init(nibName: "WPBillMessageCell", bundle: nil), forCellReuseIdentifier: WPBillMessageCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPBillMessageCell = tableView.dequeueReusableCell(withIdentifier: WPBillMessageCellID, for: indexPath) as! WPBillMessageCell
        cell.model = self.data_array[indexPath.section] as! WPBillInforListModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WPBillSectionHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        let model: WPBillInforListModel = self.data_array[section] as! WPBillInforListModel
        let titleString =  WPPublicTool.stringCustom(date: model.createDate)
        let titleWidth = titleString.count * 10
        headerView.title_label.text = titleString
        headerView.title_label.frame = CGRect(x: tableView.frame.size.width / 2 - CGFloat(titleWidth / 2), y: 7, width: CGFloat(titleWidth), height: 20)
        return headerView
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WPBillDetailController()
        vc.bill_model = (self.data_array[indexPath.section] as? WPBillInforListModel)!
        self.navigationController?.pushViewController(vc, animated: true)
        self.isRefresh = false
    }
    
    // MARK: - Request
    @objc func getBillMessageData() {
        weak var weakSelf = self
        
        WPDataTool.GETRequest(url: WPBillNotificationURL, parameters: ["curPage" : page_int], superview: self.view, view: self.noResultView, success: { (result) in
            if weakSelf?.page_int == 1 {
                weakSelf?.data_array.removeAllObjects()
            }
            
            let array: NSMutableArray = WPBillInforListModel.mj_objectArray(withKeyValuesArray: result["list"] as Any)
            
            weakSelf?.data_array = NSMutableArray.init(array: (weakSelf?.data_array.reverseObjectEnumerator().allObjects)!)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.data_array = NSMutableArray.init(array: (weakSelf?.data_array.reverseObjectEnumerator().allObjects)!)
            
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_noMessage"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
            
            if Float((weakSelf?.tableView.contentSize.height)!) > Float((weakSelf?.tableView.frame.size.height)!) {
                let indexPath = IndexPath.init(row: 0, section: (weakSelf?.data_array.count)! - 20 * ((weakSelf?.page_int)! - 1) - 1)
                weakSelf?.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: false)
            }
            
        }, networkError: { (button) in
            weakSelf?.tableView.mj_header.endRefreshing()
            button.addTarget(self, action: #selector(self.getBillMessageData), for: .touchUpInside)
        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
        }
    }
    
}
