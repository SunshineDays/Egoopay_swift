//
//  WPBankCardListController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/15.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSelectedCardType = (_ selectedCard : WPBankCardModel) -> Void

let WPBankCardListCellID = "WPBankCardListCellID"

class WPBankCardListController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorConvert(colorString: "36353A")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_jia_content_n"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addCardAction))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageFromColor(color: UIColor.colorConvert(colorString: "36353A")), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        getBankCardListData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageFromColor(color: UIColor.themeColor()), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)

    }
    
    var selectedCardInfor: WPSelectedCardType?
    
    /**
     *  判断银行卡显示类型
     *  1:全部 2:国际信用卡 3:储蓄卡 5:信用卡
     */
    var showCardType = "1"
    
    /**  是否是设置收款银行卡 */
    var isGathering = false
    
    var cardID = String()
    
    var data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPBanKCardListCell", bundle: nil), forCellReuseIdentifier: WPBankCardListCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPBanKCardListCell = tableView.dequeueReusableCell(withIdentifier: WPBankCardListCellID, for: indexPath) as! WPBanKCardListCell
        cell.model = self.data_array[indexPath.row] as! WPBankCardModel
        
        return cell
    }

    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.data_array[indexPath.row] as! WPBankCardModel
        
        if self.showCardType == "1" {
            
            let vc = WPBankCardDetailController()
            vc.card_model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            if isGathering {
                let vc = WPBankCardDetailController()
                vc.card_model = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                self.selectedCardInfor?(model)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Action
    @objc func addCardAction() {
        
        //判断是否实名认证
        WPLoadDataModel.getUserApproveStateData(approveType: true) { (isPass) in
            if WPJudgeTool.isSetPayPassword() { //判断是否设置支付密码
                WPPopToViewControllerName = self
                self.navigationController?.pushViewController(WPBankCardInputNumberController(), animated: true)
            }
            else {
                let vc = WPPasswordPayController()
                vc.isSetPassword = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    // MARK: - Request
    
    /**  获取银行卡列表 */
    @objc func getBankCardListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPUserBanKCardURL, parameters: ["cardType" : showCardType], superview: self.view, view: self.noResultView, success: { (result) in
            weakSelf?.data_array.removeAllObjects()
            let array: NSMutableArray = WPBankCardModel.mj_objectArray(withKeyValuesArray: result["cardList"] as Any)
            weakSelf?.data_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: weakSelf?.showCardType == "1" ? #imageLiteral(resourceName: "icon_noCard") : #imageLiteral(resourceName: "icon_noCards"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }, networkError: { (button) in
            button.addTarget(self, action: #selector(self.getBankCardListData), for: .touchUpInside)
        }) { (error) in
            
        }
    }
    
}
