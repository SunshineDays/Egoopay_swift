//
//  WPMyMemberDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/12.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPMyMemberDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = member_model.lvname
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "有效推荐人", style: .plain, target: self, action: #selector(self.invitePeopleAction))
        channel_array.addObjects(from: WPMemberChannelModel.mj_objectArray(withKeyValuesArray: member_model.chanelMessage) as! [Any])
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let channel_array = NSMutableArray()
    
    /**  用户当前等级升级费用 */
    var currentVipPrice = Float()
    
    var infor_model = WPUserInforModel()
    
    var member_model = WPMemberModel()
    
    lazy var footer_view: WPMyMemberDetailFooterView = {
        let view = WPMyMemberDetailFooterView()
        view.share_button.setTitle(String(format: "再推荐%d人可升级为%@", member_model.moreInvite, member_model.lvname), for: .normal)
        view.share_button.addTarget(self, action: #selector(self.shareAction), for: .touchUpInside)
        view.confirm_button.setTitle("直接升级为" + member_model.lvname, for: .normal)
        view.confirm_button.addTarget(self, action: #selector(self.payAction), for: .touchUpInside)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.addSubview(WPThemeColorView())
        tableView.tableFooterView = infor_model.merchantlvid < member_model.levelNo ? self.footer_view : UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPMyMemberDetailCell", bundle: nil), forCellReuseIdentifier: WPMyMemberDetailCellID)
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
            let cell: WPMyMemberDetailCell = tableView.dequeueReusableCell(withIdentifier: WPMyMemberDetailCellID, for: indexPath) as! WPMyMemberDetailCell
            cell.model = member_model
            return cell
        default:
            let cell: WPMyMemberDetailChannelCell = tableView.dequeueReusableCell(withIdentifier: WPMyMemberDetailChannelCellID, for: indexPath) as! WPMyMemberDetailChannelCell
            cell.model = channel_array[indexPath.row] as! WPMemberChannelModel
            return cell
        }
    }
    
    
    // MARK: - Action
    
    @objc func invitePeopleAction() {
        let vc = WPInvitePeopleController()
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareAction() {
        WPShareModel.getData { (model) in
            WPShareTool.shareToApp(model: model)
        }
    }
    
    @objc func payAction() {
        if infor_model.merchantlvid > 1 {
            weak var weakSelf = self
            WPInterfaceTool.alertController(title: String(format: "此次升级只需补齐差价(%.2f元)即可", member_model.price - currentVipPrice), confirmTitle: "去升级", confirm: { (alertAction) in
                WPPayTool.payOrderView(tradeType: (weakSelf?.member_model.tradeType)!, productId: (weakSelf?.member_model.levelNo)!, phone : "")
            }, cancel: { (alertAction) in
                
            })
        }
        else {
            WPPayTool.payOrderView(tradeType: member_model.tradeType, productId: member_model.levelNo, phone : "")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
