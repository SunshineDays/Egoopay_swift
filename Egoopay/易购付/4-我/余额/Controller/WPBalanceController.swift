//
//  WPBalanceController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBalanceController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "余额"
        getUserInforData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  用户信息模型 */
    var inforModel = WPUserInforModel()
    
    let title_array = ["充值", "提现"]
    
    let image_array = [#imageLiteral(resourceName: "icon_chongzhiB"), #imageLiteral(resourceName: "icon_tixianB")]
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPBalanceCell", bundle: nil), forCellReuseIdentifier: WPBalanceCellID)
        tableView.register(UINib.init(nibName: "WPImageTitleCell", bundle: nil), forCellReuseIdentifier: WPImageTitleCellID)
        self.view.addSubview(tableView)
        tableView.addSubview(WPThemeColorView())
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0  ? 200 : 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: WPBalanceCell = tableView.dequeueReusableCell(withIdentifier: WPBalanceCellID, for: indexPath) as! WPBalanceCell
            cell.balance_label.text = String(format: "%.2f", inforModel.avl_balance)
            return cell
        default:
            let cell: WPImageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleCellID, for: indexPath) as! WPImageTitleCell
            cell.title_imageView.image = image_array[indexPath.row - 1]
            cell.title_label.text = title_array[indexPath.row - 1]
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            self.navigationController?.pushViewController(WPAppsRechargeController(), animated: true)

        case 2:
            self.navigationController?.pushViewController(WPWithDrawController(), animated: true)
        default:
            break
        }
    }
    
    // MARK: - Action
    
    @objc func cashDepositAction() {
        let alertController = UIAlertController.init(title: String(format: "您的保证金为%.2f元", inforModel.depositeAmount), message: String(format: "如有问题，请联系客服", inforModel.depositeAmount), preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "知道了", style: .cancel, handler: { (alertAction) in
            
        }))
        self.present(alertController, animated: true) {
            
        }
    }
    
    // MARK: - Request
    
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (model) in
            weakSelf?.inforModel = model
            weakSelf?.tableView.reloadData()
            if model.depositeAmount > 0 {
                weakSelf?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保证金", style: .plain, target: self, action: #selector(self.cashDepositAction))
            }
        }) { (error) in
            
        }
    }
    

}
