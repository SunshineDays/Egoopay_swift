//
//  WPAgencyOrderController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAgencyOrderController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "确认订单"
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "WPAgencyOrderInforCell", bundle: nil), forCellReuseIdentifier: WPAgencyOrderInforCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initInfor(depositAmount: Float, agencyModel: WPAgencyProductAgUpListModel, inforAgencyModel: WPAgencyProductAgUpListModel) {
        self.depositAmount = depositAmount
        self.agency_model = agencyModel
        self.inforAgency_model = inforAgencyModel
    }
    
    /**  用户缴纳的保证金 */
    var depositAmount = Float()

    /**  升级等级模型 */
    var agency_model = WPAgencyProductAgUpListModel()

    /**  用户当前等级的产品模型 */
    var inforAgency_model = WPAgencyProductAgUpListModel()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPAgencyOrderInforCell = tableView.dequeueReusableCell(withIdentifier: WPAgencyOrderInforCellID, for: indexPath) as! WPAgencyOrderInforCell
        cell.curentDeposit = depositAmount
        cell.inforAgencyModel = inforAgency_model
        cell.agencyModel = agency_model
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        return cell
    }

    // MARK: - Action

    @objc func confirmAction() {
        WPPayTool.payOrderView(tradeType: agency_model.tradeType, productId: agency_model.agentId, phone : "")
    }

}
