//
//  WPAgencyDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAgencyDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = agency_model.gradeName

        /**  如果查看等级比用户等级高，显示下一步按钮 */
        if agency_model.agentId > inforAgency_model.agentId {
            tableViewHeight = tableViewHeight - 45
            self.view.addSubview(next_button)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initInfor(depositAmount: Float, inforAgencyModel: WPAgencyProductAgUpListModel, agencyModel: WPAgencyProductAgUpListModel) {
        self.depositAmount = depositAmount
        self.inforAgency_model = inforAgencyModel
        self.agency_model = agencyModel
        channel_array.addObjects(from: WPAgencyProductChanelMessageModel.mj_objectArray(withKeyValuesArray: agencyModel.chanelMessage) as! [Any])
    }
    
    var tableViewHeight = kScreenHeight - WPNavigationHeight
    
    /**  用户缴纳的保证金 */
    var depositAmount = Float()
    
    /**  用户当前等级的产品模型 */
    var inforAgency_model = WPAgencyProductAgUpListModel()
    
    /**  所选等级的模型 */
    var agency_model = WPAgencyProductAgUpListModel()

    /**  所选等级中通道数组 */
    let channel_array = NSMutableArray()
    
    lazy var next_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - 45, width: kScreenWidth, height: 45))
        button.backgroundColor = UIColor.themeColor()
        button.setTitle("升级为" + agency_model.gradeName, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: tableViewHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.addSubview(WPThemeColorView())
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPAgencyDetailHeaderCell", bundle: nil), forCellReuseIdentifier: WPAgencyDetailHeaderCellID)
        tableView.register(UINib.init(nibName: "WPMyMemberDetailChannelCell", bundle: nil), forCellReuseIdentifier: WPMyMemberDetailChannelCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : channel_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPAgencyDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: WPAgencyDetailHeaderCellID, for: indexPath) as! WPAgencyDetailHeaderCell
            cell.model = self.agency_model
            return cell
        default:
            let cell: WPMyMemberDetailChannelCell = tableView.dequeueReusableCell(withIdentifier: WPMyMemberDetailChannelCellID, for: indexPath) as! WPMyMemberDetailChannelCell
            cell.agency_model = channel_array[indexPath.row] as! WPAgencyProductChanelMessageModel
            return cell
        }
        
    }

    // MARK: - Action
    
    @objc func nextAction() {
        let vc = WPAgencyOrderController()
        vc.initInfor(depositAmount: depositAmount, agencyModel: agency_model, inforAgencyModel: inforAgency_model)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
