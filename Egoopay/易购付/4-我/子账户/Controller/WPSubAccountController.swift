//
//  WPSubAccountController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/1.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSubAccountController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "子账户"
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_jia_content_n"), style: .plain, target: self, action: #selector(self.rightItemAction))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSubAccountListData()
    }
    
    let data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleCellID)
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCellID, for: indexPath) as! WPTitleCell
        
        let model: WPSubAccountListModel = (data_array[indexPath.row] as? WPSubAccountListModel)!
        cell.title_label.text = model.clerkName + "(登录ID:" + String(format: "%ld", model.clerkNo) + ")"
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: WPSubAccountListModel = (data_array[indexPath.row] as? WPSubAccountListModel)!
        let vc = WPSubAccountDetailController()
        vc.listModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action
    @objc func rightItemAction() {
        WPLoadDataModel.getUserApproveStateData(approveType: false) { (isPass) in
            self.navigationController?.pushViewController(WPSubAccountAddController(), animated: true)
        }
    }
    
    // MARK: - Request
    
    func getSubAccountListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPSubAccountListURL, parameters: nil,  success: { (result) in
            weakSelf?.data_array.removeAllObjects()
            let array: NSMutableArray = WPSubAccountListModel.mj_objectArray(withKeyValuesArray: result["clerkList"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_noSubAccount"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in

        }
    }

}
