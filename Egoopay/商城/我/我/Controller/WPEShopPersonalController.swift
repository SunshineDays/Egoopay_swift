//
//  WPEShopPersonalController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopPersonalController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "我"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_goBack_goBack"), style: .plain, target: self, action: #selector(self.goBackAction))
        
        
        self.tableView.register(UINib.init(nibName: "WPEShopPersonalTitleCell", bundle: nil), forCellReuseIdentifier: WPEShopPersonalTitleCellID)
        self.tableView.register(UINib.init(nibName: "WPEShopPersonalStateCell", bundle: nil), forCellReuseIdentifier: WPEShopPersonalStateCellID)
        self.tableView.register(UINib.init(nibName: "WPEShopPersonalCell", bundle: nil), forCellReuseIdentifier: WPEShopPersonalCellID)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEShopPersonalData()
    }
    
    /**  个人信息模型 */
    var infor_model = WPEShopPersonalModel()
    
    let image_array = [#imageLiteral(resourceName: "icon_eShop_personal_myAddress"), #imageLiteral(resourceName: "icon_eShop_personal_myMoney"), #imageLiteral(resourceName: "icon_eShop_personal_help"), #imageLiteral(resourceName: "icon_eShop_personal_about")]
    
    let title_array = ["我的地址", "客服与帮助", "关于我们"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? title_array.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 15 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPEShopPersonalTitleCell = tableView.dequeueReusableCell(withIdentifier: WPEShopPersonalTitleCellID, for: indexPath) as! WPEShopPersonalTitleCell
            cell.love_button.addTarget(self, action: #selector(self.loveAction), for: .touchUpInside)
            cell.attention_button.addTarget(self, action: #selector(self.attentionAction), for: .touchUpInside)
            cell.foot_button.addTarget(self, action: #selector(self.footAction), for: .touchUpInside)
            cell.integral_button.addTarget(self, action: #selector(self.integralAction), for: .touchUpInside)
            cell.model = infor_model
            return cell
        case 1:
            let cell: WPEShopPersonalStateCell = tableView.dequeueReusableCell(withIdentifier: WPEShopPersonalStateCellID, for: indexPath) as! WPEShopPersonalStateCell
            cell.order_button.addTarget(self, action: #selector(self.orderAction(_:)), for: .touchUpInside)
            cell.waitPay_button.addTarget(self, action: #selector(self.orderAction(_:)), for: .touchUpInside)
            cell.waitSending_button.addTarget(self, action: #selector(self.orderAction(_:)), for: .touchUpInside)
            cell.waitDelivery.addTarget(self, action: #selector(self.orderAction(_:)), for: .touchUpInside)
            cell.haveBeenSigned_buton.addTarget(self, action: #selector(self.orderAction(_:)), for: .touchUpInside)
            return cell
        default:
            let cell: WPEShopPersonalCell = tableView.dequeueReusableCell(withIdentifier: WPEShopPersonalCellID, for: indexPath) as! WPEShopPersonalCell
            cell.title_imageView.image = image_array[indexPath.row]
            cell.title_label.text = title_array[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(WPEShopMyAddressController(), animated: true)
            case 1:
                contactUsAction()
            case 2:
                WPInterfaceTool.showWebViewController(url: WPAboutOurWebURL, title: "易购付")
            default:
                break
            }
        default:
            break
        }
    }
    
    
    // MARK: - Action
    
    @objc func goBackAction() {
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: nil)
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = kCATransitionMoveIn
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
        UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
        UserDefaults.standard.synchronize()
    }

    //收藏
    @objc func loveAction() {
        let vc = WPEShopMyLoveController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //关注
    @objc func attentionAction() {
        let vc = WPEShopMyLoveController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //足迹
    @objc func footAction() {
        self.navigationController?.pushViewController(WPEShopMyLookRecordController(), animated: true)
    }
    
    //积分
    @objc func integralAction() {
        WPProgressHUD.showInfor(status: "敬请期待")
//        let vc = WPEShopIntegralController()
//        vc.selectedNumber = 0
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //订单记录
    @objc func orderAction(_ button: UIButton) {
        let vc = WPEShopMyOrderController()
        vc.selectedNumber = button.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //客服与帮助
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
    
    //获取个人信息
    func getEShopPersonalData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopPersonalURL, parameters: nil, success: { (result) in
            weakSelf?.infor_model = WPEShopPersonalModel.mj_object(withKeyValues: result["user"])
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
}
