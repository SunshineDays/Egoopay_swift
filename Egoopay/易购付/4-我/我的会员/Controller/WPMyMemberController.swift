//
//  WPMyMemberController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/10.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPMyMemberController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的会员"

        getVipProductData()
        
        weak var weakSelf = self
        WPShareModel.getData(success: { (shareModel) in
            weakSelf?.share_model = shareModel
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**  数据数组 */
    var data_array = NSMutableArray()

    /**  用户信息模型 */
    var infor_model = WPUserInforModel()
    
    /**  分享信息模型 */
    var share_model = WPShareModel()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: "WPMyMemberHeaderCell", bundle: nil), forCellReuseIdentifier: WPMyMemberHeaderCellID)
        tableView.register(UINib.init(nibName: "WPMyMemberCell", bundle: nil), forCellReuseIdentifier: WPMyMemberCellID)
        self.view.addSubview(tableView)
        tableView.addSubview(WPThemeColorView())
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPMyMemberHeaderCell = tableView.dequeueReusableCell(withIdentifier: WPMyMemberHeaderCellID, for: indexPath) as! WPMyMemberHeaderCell
            cell.model = infor_model
            return cell
        default:
            let cell: WPMyMemberCell = tableView.dequeueReusableCell(withIdentifier: WPMyMemberCellID, for: indexPath) as! WPMyMemberCell
            cell.model = data_array[indexPath.row] as! WPMemberModel
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if WPJudgeTool.isText() {
            weak var weakSelf = self
            let array = [0, 10, 30, 50]
            let vipNameArray = ["白银会员", "黄金会员", "铂金会员", "钻石会员"]
            if indexPath.row == 0 {
                WPProgressHUD.showInfor(status: "您已是白银会员，去升级更高等级吧")
            }
            else {
                WPInterfaceTool.alertController(title: String(format: "推荐%d个实名认证用户可以升级为%@", array[indexPath.row], vipNameArray[indexPath.row]), confirmTitle: "去推荐", confirm: { (action) in
                    WPShareTool.shareToApp(model: (weakSelf?.share_model)!)
                }, cancel: { (action) in
                    
                })
            }
        }
        else {
            let model: WPMemberModel = data_array[indexPath.row] as! WPMemberModel
            let vc = WPMyMemberDetailController()
            vc.member_model = model
            vc.infor_model = infor_model
            vc.currentVipPrice = (data_array[infor_model.merchantlvid - 1] as! WPMemberModel).price
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    //MARK: - Request
    @objc func getVipProductData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPShowMerUpgradeURL, parameters: nil, superview: self.view, view: self.noResultView, success: { (result) in
            weakSelf?.data_array.addObjects(from: WPMemberModel.mj_objectArray(withKeyValuesArray: result["merLvList"]) as! [Any])
            weakSelf?.getUserInforData()
            
        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getVipProductData), for: .touchUpInside)
        }) { (error) in
            
        }
    }
    
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (model) in
            weakSelf?.infor_model = model
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    
    
}
