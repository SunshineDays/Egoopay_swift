//
//  WPHomePageController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/3/8.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPHomePageController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.reloadData()
        
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
        
        //如果轮播图加载失败，重新加载
        if header_view.scrollView.imageURLStringsGroup == nil {
            getScrollViewData()
        }
    }
    
    lazy var header_view: WPHomePageHeaderView = {
        let view = WPHomePageHeaderView()
        view.collectionViewA.delegate = self
        view.collectionViewB.delegate = self
        return view
    }()
    
    lazy var logo_imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: kScreenWidth / 2 - 25, y: -100, width: 50, height: 50))
        imageView.image = #imageLiteral(resourceName: "icon_logo")
        return imageView
    }()
    
    
    let content_array = [[#imageLiteral(resourceName: "icon_guojixinyongkaA"), #imageLiteral(resourceName: "icon_shangjiaruzhu"), #imageLiteral(resourceName: "icon_shanghushengjiA"), #imageLiteral(resourceName: "icon_dailishengjiA")], ["", "商家入驻", "我的会员", "成为合伙人"], ["", "全国招商 商家免费入驻", "信用消费 安全无忧", "携同全球合伙人 共赢创造财富未来"], ["", "免费推广 服务全城", "消费费率低至0.32%", "免费提供帮助和服务"], ["", "2AB3B4", "0378DB", "E98540"]]

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPTabBarHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.header_view
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        tableView.register(UINib.init(nibName: "WPHomePagesCell", bundle: nil), forCellReuseIdentifier: WPHomePagesCellID)
        tableView.addSubview(logo_imageView)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return content_array[0].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPHomePagesCell = tableView.dequeueReusableCell(withIdentifier: WPHomePagesCellID, for: indexPath) as! WPHomePagesCell
        if indexPath.section == 0 {
            cell.background_imageView.image = content_array[0][indexPath.section] as? UIImage
            
        }
        else {
            cell.title_imageView.image = content_array[0][indexPath.section] as? UIImage
            cell.titleA_label.text = content_array[1][indexPath.section] as? String
            cell.titleB_label.text = content_array[2][indexPath.section] as? String
            cell.titleC_label.text = content_array[3][indexPath.section] as? String
            cell.titleB_label.textColor = UIColor.colorConvert(colorString: content_array[4][indexPath.section] as! String)
        }
        cell.background_imageView.isHidden = indexPath.section != 0
        cell.title_imageView.isHidden = indexPath.section == 0
        cell.titleA_label.isHidden = indexPath.section == 0
        cell.titleB_label.isHidden = indexPath.section == 0
        cell.titleC_label.isHidden = indexPath.section == 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            internationalAction()
        case 1:
            shopEnterAction()
        case 2:
            myMemberAction()
        case 3:
            partnerAction()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == header_view.collectionViewA {
            switch indexPath.row {
            case 0:
                gatheringAction()
            case 1:
                creditAction()
            default:
                break
            }
        }
        else {
            switch indexPath.row {
            case 0:
                billAction()
            case 1:
                creditApplyAction()
            case 2:
                loansAction()
            case 3:
                eShopAction()
            case 4:
                phoneAction()
            case 5:
                shopAction()
            case 6:
                withDrawAction()
            default:
                break
            }
        }
    }
    
    // MARK: - Action
    
    @objc func gatheringAction() {
        WPLoadDataModel.getUserApproveStateData(approveType: false) { (isPass) in
            self.navigationController?.pushViewController(WPMyGatheringCodeController(), animated: true)
        }
    }
    
    @objc func creditAction() {
        self.navigationController?.pushViewController(WPCreditSelectChannelController(), animated: true)
    }
    
    
    @objc func shopAction() {
        self.navigationController?.pushViewController(WPShopController(), animated: true)
    }
    
    @objc func billAction() {
        self.navigationController?.pushViewController(WPBillListController(), animated: true)
    }
    
    @objc func phoneAction() {
        let vc = WPPhoneChargeController()
        vc.navigationItem.title = "手机充值"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func withDrawAction() {
        self.navigationController?.pushViewController(WPWithDrawController(), animated: true)
    }
    
    @objc func eShopAction() {
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: "YES")
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = kCATransitionMoveIn
        animation.subtype = kCATransitionFromRight
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
        UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
        UserDefaults.standard.synchronize()
    }
    
    @objc func creditApplyAction() {
        WPInterfaceTool.showWebViewController(url: WPCreditApplyURL, title: "信用卡申请")
    }
    
    @objc func loansAction() {
        WPInterfaceTool.showWebViewController(url: WPLoansURL, title: "小额贷款")
    }
    
    @objc func internationalAction() {
        self.navigationController?.pushViewController(WPInternationalChargeController(), animated: true)
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
        self.navigationController?.pushViewController(WPAgencyProductController(), animated: true)
    }

    // MARK: - Request
    
    /** 获取ScrollView数据 */
    func getScrollViewData() {
        weak var weakSelf = self
        WPLoadDataModel.getData(bannerCode: "1") { (dataArray) in
            weakSelf?.header_view.scrollView.imageURLStringsGroup = dataArray
            weakSelf?.header_view.scrollView.reloadInputViews()
        }
    }
    
}
