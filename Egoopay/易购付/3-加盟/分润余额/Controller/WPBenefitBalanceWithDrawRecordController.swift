//
//  WPBenefitBalanceWithDrawRecordController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/26.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPBenefitBalanceWithDrawRecordController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "提现记录"
        getWithDrawRecordRequest(page: page)
        weak var weakSelf = self
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page = (weakSelf?.page)! + 1
            weakSelf?.getWithDrawRecordRequest(page: (weakSelf?.page)!)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let data_array = NSMutableArray()
    
    var page = 1
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPBenefitWithDrawRecordCell", bundle: nil), forCellReuseIdentifier: WPBenefitWithDrawRecordCellID)
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
        let cell: WPBenefitWithDrawRecordCell = tableView.dequeueReusableCell(withIdentifier: WPBenefitWithDrawRecordCellID, for: indexPath) as! WPBenefitWithDrawRecordCell
        cell.model = data_array[indexPath.row] as! WPBenefitWithDrawRecordModel
        return cell
    }

    
    func getWithDrawRecordRequest(page: NSInteger) {
        let parameter = ["curPage" : page]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: wpProfitWithDrawURL, parameters: parameter, success: { (result) in
            let array: NSMutableArray = WPBenefitWithDrawRecordModel.mj_objectArray(withKeyValuesArray: result["list"])
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: nil, title: "暂无分润提现记录")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            if page > 1 {
                weakSelf?.page = page - 1
            }
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }

}
