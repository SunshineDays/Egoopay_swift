//
//  WPShopDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPShopDetailController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "WPShopDetailCell", bundle: nil), forCellReuseIdentifier: WPShopDetailCellID)
        tableView.separatorStyle = .none
        
        if shopModel.shopName != "" {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
        else {
            self.navigationItem.title = "我的商家信息"
            getShopDetailData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shopID = NSInteger()
    
    var shopModel = WPShopDetailModel()

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPShopDetailCell = tableView.dequeueReusableCell(withIdentifier: WPShopDetailCellID, for: indexPath) as! WPShopDetailCell
        cell.model = shopModel
        cell.shopAddress_button.addTarget(self, action: #selector(self.goToOtherAppAction), for: .touchUpInside)
        cell.shopTel_button.addTarget(self, action: #selector(self.callToNumberAction), for: .touchUpInside)
        return cell
    }
    
    // MAARK: - Action
    
    @objc func goToOtherAppAction() {
        let cell: WPShopDetailCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopDetailCell
        let address = cell.shopAddress_button.currentTitle!
        
        let alertController = UIAlertController.init(title: "选择地图", message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://path")!) {
            alertController.addAction(UIAlertAction.init(title: "高德地图", style: .default, handler: { (action) in
                let url = "iosamap://path?sourceApplication=applicationName" + "&sid=BGVIS1" + "&name=" + "我的位置" + "&did=BGVIS2" + "&dname=" + address + "&dev=0" + "&t=0"
                UIApplication.shared.open(URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:], completionHandler: nil)
            }))
        }
        
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://map/maker")!) {
            alertController.addAction(UIAlertAction.init(title: "百度地图", style: .default, handler: { (action) in
                let url = "baidumap://map/direction?origin=" + "我的位置" + "&destination=" + address + "&mode=driving" + "&region=" + (weakSelf?.shopModel.city)!
                UIApplication.shared.open(URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:], completionHandler: nil)
            }))
        }
        
        alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @objc func shopAddressAction(_ button: UIButton) {
        let cell: WPShopDetailCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopDetailCell
        let vc = WPAMapLocationController()
        vc.address = cell.shopAddress_button.currentTitle!
        vc.city = shopModel.city
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func callToNumberAction() {
        WPInterfaceTool.callToNum(numString: shopModel.telephone)
    }
    
    // MARK: - Request
    
    func getShopDetailData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPMerShopDetailURL, parameters: ["shop_id" : shopID], success: { (result) in
            weakSelf?.shopModel = WPShopDetailModel.mj_object(withKeyValues: result)
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
}
