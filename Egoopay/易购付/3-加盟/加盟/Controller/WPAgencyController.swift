//
//  WPAgencyController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAgencyController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "加盟"
        getScrollViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAgencyInforData()
    }
    
    var agency_model = WPAgencyModel()
    
    let title_array = ["分润明细", "邀请的人", "加入我们"]
    
    let content_array = ["按笔分润一目了然", "邀好友 赚分润", "开启赚钱之旅"]
    
    let image_array = [#imageLiteral(resourceName: "icon_dailijieshao"), #imageLiteral(resourceName: "icon_dailishengjiF"), #imageLiteral(resourceName: "icon_yaoqing")]
    
    lazy var header_view: WPAgencyHeaderView = {
        let view = WPAgencyHeaderView()
        view.initData(today: self.agency_model.todayBenef, balance: self.agency_model.benefitBalance)
        view.collectionView.delegate = self
        return view
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - WPTabBarHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableHeaderView = self.header_view
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPAgencyCell", bundle: nil), forCellReuseIdentifier: WPAgencyCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPAgencyCell = tableView.dequeueReusableCell(withIdentifier: WPAgencyCellID, for: indexPath) as! WPAgencyCell
        cell.titleA_label.text = title_array[indexPath.row]
        cell.titleB_label.text = content_array[indexPath.row]
        cell.title_imageView.image = image_array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(WPBenefitDetailController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(WPInvitePeopleController(), animated: true)
        case 2:
            if WPJudgeTool.isText() {
                WPLoadDataModel.getUserApproveStateData(approveType: false) { (isPass) in
                    self.navigationController?.pushViewController(WPAgencyProductController(), animated: true)
                }
            }
            else {
                self.navigationController?.pushViewController(WPAgencyProductController(), animated: true)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = WPBenefitDetailController()
            vc.showType = 3
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.navigationController?.pushViewController(WPBenefitBalanceController(), animated: true)
        default:
            break
        }
    }

    // MARK: - Request
    
    /**  获取代理信息 */
    @objc func getAgencyInforData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPAgencyURL, parameters: nil, superview: self.view, view: self.noResultView, success: { (result) in
            weakSelf?.agency_model = WPAgencyModel.mj_object(withKeyValues: result)
            weakSelf?.tableView.reloadData()
            weakSelf?.header_view.collectionView.reloadData()
            weakSelf?.header_view.initData(today: (weakSelf?.agency_model.todayBenef)!, balance: (weakSelf?.agency_model.benefitBalance)!)
            if weakSelf?.header_view.scrollView.imageURLStringsGroup == nil {
                weakSelf?.getScrollViewData()
            }
        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getAgencyInforData), for: .touchUpInside)
        }) { (error) in
            
        }
        
    }
    
    /** 获取ScrollView数据 */
    func getScrollViewData() {
        weak var weakSelf = self
        WPLoadDataModel.getData(bannerCode: "3") { (dataArray) in
            weakSelf?.header_view.scrollView.imageURLStringsGroup = dataArray
            weakSelf?.header_view.scrollView.reloadInputViews()
        }
    }
    
    
}
