//
//  WPMyGatheringCodeController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPMyGatheringCodeController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "我的收款码"
        self.tableView.register(UINib.init(nibName: "WPMyGatheringCodeCell", bundle: nil), forCellReuseIdentifier: WPMyGatheringCodeCellID)
        self.tableView.backgroundColor = UIColor.themeColor()
        self.tableView.separatorStyle = .none
        getGatheringCodeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var code_model = WPMyCodeModel()
    
    /**  是否显示设置的金额 */
    var isShow = false
    
    /**  设置金额的二维码图片 */
    var moneyCode_image = UIImage()
    
    /**  设置的金额 */
    var moneyNumber = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPMyGatheringCodeCell = tableView.dequeueReusableCell(withIdentifier: WPMyGatheringCodeCellID, for: indexPath) as! WPMyGatheringCodeCell
        
        cell.isShow = isShow
        cell.moneyCode_image = moneyCode_image
        cell.moneyNumber = moneyNumber
        cell.model = code_model
        
        cell.set_button.addTarget(self, action: #selector(self.buildMoneyAction), for: .touchUpInside)
        cell.today_button.addTarget(self, action: #selector(self.todayGathering), for: .touchUpInside)
        cell.record_button.addTarget(self, action: #selector(self.recodeGathering), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight - WPNavigationHeight
    }
    
    
    // MARK: - Action
    
    /**  设置金额/清除金额 */
    @objc func buildMoneyAction() {
        if isShow { //清除金额
            isShow = !isShow
            tableView.reloadData()
        }
        else { //设置金额
            //判断是否设置收款银行卡
            if code_model.isExistReceiveBank == "OK" {
                let vc = WPCodeBuildMoneyController()
                weak var weakSelf = self
                vc.buildCodeMoneyType = {(codeUrl, money, isWechat) -> Void in
                    weakSelf?.moneyCode_image = SGQRCodeTool.sg_generate(withLogoQRCodeData: codeUrl, logoImage: isWechat ? #imageLiteral(resourceName: "icon_wechatLine") : #imageLiteral(resourceName: "icon_alipyLine"), logoScaleToSuperView: 0.2)
                    weakSelf?.isShow = true
                    weakSelf?.moneyNumber = money
                    weakSelf?.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                WPInterfaceTool.alertController(title: "您还没有绑定收款银行卡", confirmTitle: "去绑定", confirm: { (alertAction) in
                    let vc = WPBankCardListController()
                    vc.navigationItem.title = "设置收款银行卡"
                    vc.showCardType = "3"
                    vc.isGathering = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }, cancel: { (alertAction) in

                })
            }
        }
        
    }
    
    /**  今日收款 */
    @objc func todayGathering() {
        let vc = WPGatheringRecordController()
        vc.isToday = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**  收款纪录 */
    @objc func recodeGathering() {
        self.navigationController?.pushViewController(WPGatheringRecordController(), animated: true)
    }
    
    // MARK: - Request
    
    /**  获取二维码 */
    @objc func getGatheringCodeData() {
        weak var weakSelf = self
        
        WPDataTool.GETRequest(url: WPGatheringCodeURL, parameters: nil, superview: self.view, view: self.noResultView, success: { (result) in
            let model: WPMyCodeModel = WPMyCodeModel.mj_object(withKeyValues: result)
            weakSelf?.code_model = model
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()

            weakSelf?.getTodayGatheringRecordData()

        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getGatheringCodeData), for: .touchUpInside)
        }) { (error) in
            
        }
    }
    
    func getTodayGatheringRecordData() {
        let parameter = ["curPage" : "",
                         "queryDate" : ""] as [String : Any]
        
        weak var weakSelf = self
        
        WPDataTool.GETRequest(url: WPTodayGatheringRecordURL, parameters: parameter, success: { (result) in
            let cell: WPMyGatheringCodeCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPMyGatheringCodeCell
            
            let model: WPMyCodeResultModel = WPMyCodeResultModel.mj_object(withKeyValues: result)
            cell.today_label.text = String(format: "%.2f", model.todayQrIncome)

        }) { (error) in
            
        }
    }

}
