//
//  WPInvitePeopleController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPInvitePeopleController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "邀请的人"
        // Do any additional setup after loading the view.
        getInvitingPeopleData()
        weak var weakSelf = self
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page += 1
            weakSelf?.getInvitingPeopleData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * 0、所有推荐人 1、有效推荐人 2、已经使用过的有效推荐人
     */
    var type = 0
    
    var page = 1

    var data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPInvitePeopleCell", bundle: nil), forCellReuseIdentifier: WPInvitePeopleCellID)
        
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
        let cell: WPInvitePeopleCell = tableView.dequeueReusableCell(withIdentifier: WPInvitePeopleCellID, for: indexPath) as! WPInvitePeopleCell
        let model: WPInvitingPeopleModel = data_array[indexPath.row] as! WPInvitingPeopleModel
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WPBenefitDetailController()
        vc.showType = 2
        let model: WPInvitingPeopleModel = data_array[indexPath.row] as! WPInvitingPeopleModel
        vc.referModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Request
    func getInvitingPeopleData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPMyRefersURL, parameters: ["curPage" : page, "type" : type], success: { (result) in
            if weakSelf?.page == 1 {
                weakSelf?.data_array.removeAllObjects()
            }
            let array: NSMutableArray = WPInvitingPeopleModel.mj_objectArray(withKeyValuesArray: result["map"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_noInvitePeople"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
    
    
}
