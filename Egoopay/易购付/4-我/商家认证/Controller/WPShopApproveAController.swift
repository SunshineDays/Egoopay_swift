//
//  WPShopApproveAController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/5.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPShopApproveAController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "商家认证"
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.cityName(_:)), name: WPNotificationSelectedAddress, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WPNotificationSelectedAddress, object: nil)
    }
    
    /**  选择的地址模型 */
    var address_model = WPSelectedAddressModel()
    
    /**  选择的分类模型 */
    var category_model = WPCategoryListModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPShopInforInputACell", bundle: nil), forCellReuseIdentifier: WPShopInforInputACellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPShopInforInputACell = tableView.dequeueReusableCell(withIdentifier: WPShopInforInputACellID, for: indexPath) as! WPShopInforInputACell
        cell.sex_button.addTarget(self, action: #selector(self.sexAction), for: .touchUpInside)
        cell.shopAddress_button.addTarget(self, action: #selector(self.addressAction), for: .touchUpInside)
        cell.shopCategory_button.addTarget(self, action: #selector(self.categoryAction), for: .touchUpInside)
        cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    // MARK: - Action
    
    //选择性别
    @objc func sexAction() {
        let cell: WPShopInforInputACell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopInforInputACell
        WPInterfaceTool.alertController(title: nil, rowOneTitle: "男", rowTwoTitle: "女", rowOne: { (alertAction) in
            cell.sex_button.setTitle(alertAction.title!, for: .normal)
        }) { (alertAction) in
            cell.sex_button.setTitle(alertAction.title!, for: .normal)
        }
    }
    
    //选择地址
    @objc func addressAction() {
        self.navigationController?.pushViewController(WPSelectAddresssController(), animated: true)
    }
    
    @objc func cityName(_ notification: Notification) {
        address_model = notification.userInfo!["model"] as! WPSelectedAddressModel
        let cell: WPShopInforInputACell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopInforInputACell
        cell.shopAddress_button.setTitle(address_model.province + " " + address_model.city + " " + address_model.area, for: .normal)
    }
    
    //选择分类
    @objc func categoryAction() {
        let vc = WPSelectInforController()
        weak var weakSelf = self
        vc.selectCategory = {(model) -> Void in
            weakSelf?.category_model = model
            let cell: WPShopInforInputACell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopInforInputACell
            cell.shopCategory_button.setTitle(model.name, for: .normal)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextAction() {
        let cell: WPShopInforInputACell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPShopInforInputACell
        if !WPJudgeTool.validate(mobile: cell.tel_textField.text!) && !WPJudgeTool.validate(tel: cell.tel_textField.text!) {
            WPProgressHUD.showInfor(status: "电话号码格式错误")
        }
        else {
            let dic = ["linkMan" : cell.linkName_textField.text!,
                       "linkManSex" : cell.sex_button.currentTitle! == "男" ? "1" : "2",
                       "telephone" : cell.tel_textField.text!,
                       "shopName" : cell.shopName_textField.text!,
                       "country" : "中国",
                       "province" : address_model.province,
                       "city" : address_model.city,
                       "area" : address_model.area,
                       "detailAddr" : cell.shopAddressDetail_textField.text!,
                       "categoryId" : category_model.id,
                       "shopDescription": cell.shopDescp_textView.text!] as [String : Any]
            let vc = WPShopApproveBController()
            vc.infor_dic.addEntries(from: dic)
            self.navigationController?.pushViewController(vc, animated: true)
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
