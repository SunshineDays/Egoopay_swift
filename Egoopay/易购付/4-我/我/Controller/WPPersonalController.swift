//
//  WPPersonalController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPersonalController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我"
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_setting"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.setAction))
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.getUserInforData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInforData()
        if !(self.shareModel.title.count > 0) {
            weak var weakSelf = self
            WPShareModel.getData(success: { (shareModel) in
                weakSelf?.shareModel = shareModel
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  分享信息模型 */
    var shareModel = WPShareModel()
    
    /**  数据模型 */
    var inforModel = WPUserInforModel()
    
    /**  标题图片数组 */
    let image_array = [[#imageLiteral(resourceName: "icon_shanghushengji1")], [#imageLiteral(resourceName: "icon_yue1"), #imageLiteral(resourceName: "icon_yinhangka1")], [#imageLiteral(resourceName: "icon_xiaoxi1"), #imageLiteral(resourceName: "icon_zizhanghu1")], [#imageLiteral(resourceName: "icon_pictureCourse"), #imageLiteral(resourceName: "icon_fenxiang1")]];
    
    /**  标题数组 */
    let title_array = [["我的会员"], ["余额", "银行卡"], ["消息中心", "子账户"], ["使用教程", "分享易购付"]];
    
    var money = "0.00元"
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPTabBarHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib.init(nibName: "WPPersonalTitleCell", bundle: nil), forCellReuseIdentifier: WPPersonalTitleCellID)

        tableView.register(UINib.init(nibName: "WPImageTitleContentCell", bundle: nil), forCellReuseIdentifier: WPImageTitleContentCellID)
        self.view.addSubview(tableView)
        tableView.addSubview(WPThemeColorView())
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.title_array.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (self.title_array[section - 1] as NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WPPersonalTitleCell = tableView.dequeueReusableCell(withIdentifier: WPPersonalTitleCellID, for: indexPath) as! WPPersonalTitleCell
            cell.model = self.inforModel
            return cell
        }
        else {
            let cell: WPImageTitleContentCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleContentCellID, for: indexPath) as! WPImageTitleContentCell
            cell.title_imgeView.image = (self.image_array[indexPath.section - 1] as NSArray)[indexPath.row] as? UIImage
            cell.title_label.text = (self.title_array[indexPath.section - 1] as NSArray)[indexPath.row] as? String
            if indexPath.section == 1 {
                cell.content_label.text = WPInforTypeTool.userVip(merchantlvID: self.inforModel.merchantlvid)
            }
            else if indexPath.section == 2 && indexPath.row == 0 {
                cell.content_label.text = money
            }
            else {
                cell.content_label.isHidden = true
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 106 : 55
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            jumpToUserInforVC()
        case 1:
            let vc = WPMyMemberController()
            vc.infor_model = self.inforModel
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(WPBalanceController(), animated: true)
            case 1:
                let vc = WPBankCardListController()
                vc.navigationItem.title = "我的银行卡"
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(WPMessageController(), animated: true)
            case 1:
                self.navigationController?.pushViewController(WPSubAccountController(), animated: true)
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(WPVideoCourseController(), animated: true)
            case 1:
                WPShareTool.shareToApp(model: self.shareModel)
            default:
                break
            }
        default:
            break
        }
    }
    
    @objc func jumpToUserInforVC() {
        let vc = WPUserInforController()
        vc.infor_model = self.inforModel
        weak var weakSelf = self
        vc.changeAvater = {(image) -> Void in
            weakSelf?.getUserInforData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setAction() {
        self.navigationController?.pushViewController(WPSettingController(), animated: true)
    }
    
    // MARK: - Reauest
    
    @objc func getUserInforData() {
        weak var weakSelf = self
        
        WPDataTool.GETRequest(url: WPUserInforURL, parameters: nil, superview: self.view, view: self.noResultView, success: { (result) in
            weakSelf?.inforModel = WPUserInforModel.mj_object(withKeyValues: result)
            weakSelf?.money = String(format: "%.2f元", (weakSelf?.inforModel.avl_balance)!)
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()
        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getUserInforData), for: .touchUpInside)
        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
        }
    }


}
