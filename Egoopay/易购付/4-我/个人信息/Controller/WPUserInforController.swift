//
//  WPUserInforController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/18.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias ChangeAvaterType = (_ avaterImage : UIImage) -> Void

let WPUserInforsCellID = "WPUserInforsCellID"

class WPUserInforController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "个人信息"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInforData()
    }
    
    var changeAvater: ChangeAvaterType?
    
    /**  用户信息模型 */
    var infor_model = WPUserInforModel()
    
    /**  标题数组 */
    let title_array = [["个人主页"], ["实名认证", "商家认证"], ["我的收款码", "我的客服"]]
    
    /**  内容数组 */
    var content_array = NSArray()
    
    /**  实名认证信息模型 */
    var approve_model = WPUserApproveModel()
    /**  商家认证信息模型 */
    var merchant_model = WPUserMerchantInforModel()
    
    /**  实名认证状态 */
    var approveState = String()
    /**  商家认证状态 */
    var merchantState = String()
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.tableFooterView = UIView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UINib.init(nibName: "WPTitleImageCell", bundle: nil), forCellReuseIdentifier: WPTitleImageCellID)
        tempTableView.register(UINib.init(nibName: "WPTitleContentCell", bundle: nil), forCellReuseIdentifier: WPTitleContentCellID)
        tempTableView.register(UINib.init(nibName: "WPUserApproveCell", bundle: nil), forCellReuseIdentifier: WPUserApproveCellID)

        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.title_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.title_array[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || (indexPath.section == 2 && indexPath.row == 0) {
            let cell: WPTitleImageCell = tableView.dequeueReusableCell(withIdentifier: WPTitleImageCellID, for: indexPath) as! WPTitleImageCell
            cell.title_label.text = title_array[indexPath.section][indexPath.row]
            if indexPath.section == 0 {//头像
                cell.content_imageView.sd_setImage(with: URL.init(string: infor_model.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"), options: .refreshCached)
            }
            else {// 收款码
                cell.content_imageView.image = #imageLiteral(resourceName: "icon_erweima1")
            }
            return cell
        }
        else if indexPath.section == 1 {//实名／商家认证
            let cell: WPUserApproveCell = tableView.dequeueReusableCell(withIdentifier: WPUserApproveCellID, for: indexPath) as! WPUserApproveCell
            cell.title_label.text = title_array[indexPath.section][indexPath.row]
            cell.content_label.text = indexPath.row == 0 ? approveState : merchantState
            return cell
        }
        else {//客服电话
            let cell: WPTitleContentCell = tableView.dequeueReusableCell(withIdentifier: WPTitleContentCellID, for: indexPath) as! WPTitleContentCell
            cell.title_label.text = title_array[indexPath.section][indexPath.row]
            cell.content_label.text = ""
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0 && indexPath.row == 0) ? 70 : 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: // 头像
                avaterAction()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:// 实名认证
                userApprove()
            case 1:// 商家认证
                shopApprove()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:// 我的收款码
                gatheringCodeAction()
            case 1:
                contactUsAction()
            default:
                break
            }
        default:
            break
        }
    }
    
    
    // MARK: - Action
    
    func avaterAction() {
        self.navigationController?.pushViewController(WPUserHomePageController(), animated: true)
    }
    
    func userApprove() {
        switch infor_model.iscertified {
        case 1: //已认证
            let vc = WPUserApproveInforController()
            vc.avater_url = infor_model.picurl
            self.navigationController?.pushViewController(vc, animated: true)
        case 3: //认证中
            break
        default: //未认证/认证失败
            self.navigationController?.pushViewController(WPUserApproveNumberController(), animated: true)
        }
    }
    
    func shopApprove() {
        if infor_model.iscertified == 1 {
            switch infor_model.shopCertifyState {
            case 1: //已认证
                let vc = WPShopDetailController()
                vc.shopID = infor_model.shopId
                self.navigationController?.pushViewController(vc, animated: true)
            case 3: //认证中
                break
            default: //未认证/认证失败
                self.navigationController?.pushViewController(WPShopApproveAController(), animated: true)
            }
        }
        else {
            WPProgressHUD.showInfor(status: "请先通过实名认证")
        }
    }
    
    func gatheringCodeAction() {
        if infor_model.shopCertifyState == 1 {
            self.navigationController?.pushViewController(WPMyGatheringCodeController(), animated: true)
        }
        else {
            WPProgressHUD.showInfor(status: "您还没有通过商家认证")
        }
    }
    
    func contactUsAction() {
        WPInterfaceTool.alertController(title: "请选择", rowOneTitle: "客服电话", rowTwoTitle: "客服QQ", rowOne: { (action) in
            WPInterfaceTool.callToNum(numString: WPAppTelNumber)
        }, rowTwo: { (action) in
            if UIApplication.shared.canOpenURL(URL.init(string: "mqq://")!) {
                let webView = UIWebView.init(frame: CGRect.zero)
                let url = URL.init(string: "mqq://im/chat?chat_type=wpa&uin=" + WPAppQQNumber + "&version=1&src_type=web")
                let request = URLRequest.init(url: url!)
                webView.delegate = self
                webView.loadRequest(request)
                self.view.addSubview(webView)
            }
            else {
                WPProgressHUD.showInfor(status: "您还没有安装QQ")
            }
            
        })
    }

    // MARK: - Request
    
    /**  获取用户信息 */
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (inforModel) in
            weakSelf?.infor_model = inforModel
            switch weakSelf?.infor_model.iscertified {
            case 1?:
                weakSelf?.approveState = "已认证"
            case 2?:
                weakSelf?.approveState = "认证失败"
            case 3?:
                weakSelf?.approveState = "认证中"
            default:
                weakSelf?.approveState = "未认证"
            }
            switch weakSelf?.infor_model.shopCertifyState {
            case 1?:
                weakSelf?.merchantState = "已认证"
            case 2?:
                weakSelf?.merchantState = "认证失败"
            case 3?:
                weakSelf?.merchantState = "认证中"
            default:
                weakSelf?.merchantState = "未认证"
            }
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
}
