//
//  WPSelectAppController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSelectdAppInforType = (_ title : String) -> Void

class WPSelectAppController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择支付方式"
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectAppInfor: WPSelectdAppInforType?
    
    let title_array = ["支付宝支付", "微信支付", "QQ钱包支付"]

    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPImageTitleCell", bundle: nil), forCellReuseIdentifier: WPImageTitleCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPImageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleCellID, for: indexPath) as! WPImageTitleCell
        cell.title_label.text = title_array[indexPath.row]
        cell.title_imageView.image = WPInforTypeTool.appImage(appName: title_array[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectAppInfor?(title_array[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

}
