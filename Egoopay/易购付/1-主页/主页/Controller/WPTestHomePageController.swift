//
//  WPTestHomePageController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/18.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPTestHomePageController: WPBaseViewPlainController, SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPTabBarHeight)
        self.tableView.register(UINib.init(nibName: "WPTestHomePageCell", bundle: nil), forCellReuseIdentifier: WPTestHomePageCellID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = scrollView
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        self.tableView.addSubview(logo_imageView)
        self.tableView.reloadData()
        getScrollViewData()
        //如果没有设置支付密码，检查是否设置
        if !WPJudgeTool.isSetPayPassword() {
            WPLoadDataModel.getIsSetPayPasswordData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if scrollView.imageURLStringsGroup == nil {
            getScrollViewData()
        }
    }

    lazy var logo_imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: kScreenWidth / 2 - 25, y: -100, width: 50, height: 50))
        imageView.image = #imageLiteral(resourceName: "icon_logo")
        return imageView
    }()
    
    lazy var scrollView: SDCycleScrollView = {
        let scrollView = SDCycleScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 570 / 1080)
        scrollView.bannerImageViewContentMode = UIViewContentMode.scaleAspectFill
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        scrollView.delegate = self
        return scrollView
    }()
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPTestHomePageCell = tableView.dequeueReusableCell(withIdentifier: WPTestHomePageCellID, for: indexPath) as! WPTestHomePageCell

        cell.gathering_button.addTarget(self, action: #selector(self.gatheringAction), for: .touchUpInside)
        cell.bill_button.addTarget(self, action: #selector(self.billAction), for: .touchUpInside)
        
        cell.shop_button.addTarget(self, action: #selector(self.shopAction), for: .touchUpInside)
        cell.phone_button.addTarget(self, action: #selector(self.phoneAction), for: .touchUpInside)
        cell.withDraw_button.addTarget(self, action: #selector(self.withDrawAction), for: .touchUpInside)
        cell.transfer_button.addTarget(self, action: #selector(self.transferAction), for: .touchUpInside)
        cell.code_button.addTarget(self, action: #selector(self.codeAction), for: .touchUpInside)
        
        cell.shopEnter_button.addTarget(self, action: #selector(self.shopEnterAction), for: .touchUpInside)
        cell.myMember_button.addTarget(self, action: #selector(self.myMemberAction), for: .touchUpInside)
        cell.partner_button.addTarget(self, action: #selector(self.partnerAction), for: .touchUpInside)

        return cell
    }
    
    
    // MARK: - Action
    
    @objc func gatheringAction() {
        WPLoadDataModel.getUserApproveStateData(approveType: false) { (isPass) in
            self.navigationController?.pushViewController(WPShopController(), animated: true)
        }
    }
    
    @objc func billAction() {
        self.navigationController?.pushViewController(WPBillListController(), animated: true)
    }
    
    @objc func shopAction() {
        self.navigationController?.pushViewController(WPShopController(), animated: true)
    }
    
    @objc func phoneAction() {
        let vc = WPPhoneChargeController()
        vc.navigationItem.title = "手机充值"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func withDrawAction() {
        self.navigationController?.pushViewController(WPWithDrawController(), animated: true)
    }
    
    @objc func transferAction() {
        WPProgressHUD.showInfor(status: "敬请期待")
    }
    
    @objc func codeAction() {
//        WPProgressHUD.showInfor(status: "敬请期待")
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: "YES")
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = kCATransitionMoveIn
        animation.subtype = kCATransitionFromRight
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
        UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
        UserDefaults.standard.synchronize()
    }
    
    @objc func shopEnterAction() {
        WPLoadDataModel.getUserApproveStateData(approveType: false) { (isPass) in
            self.navigationController?.pushViewController(WPShopController(), animated: true)
        }
    }
    
    @objc func myMemberAction() {
        self.navigationController?.pushViewController(WPMyMemberController(), animated: true)
    }
    
    @objc func partnerAction() {
        WPLoadDataModel.getUserApproveStateData(approveType: false) { (isPass) in
            self.navigationController?.pushViewController(WPAgencyProductController(), animated: true)
        }
    }
    
    // MARK: - Request
    
    /** 获取ScrollView数据 */
    func getScrollViewData() {
        weak var weakSelf = self
        WPLoadDataModel.getData(bannerCode: "1") { (dataArray) in
            weakSelf?.scrollView.imageURLStringsGroup = dataArray
            weakSelf?.scrollView.reloadInputViews()
        }
    }
    
}
