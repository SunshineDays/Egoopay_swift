//
//  WPSettingAccountController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSettingAccountController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "账号管理"
        // Do any additional setup after loading the view.
        getUserInforData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var infor_model = WPUserInforModel()

    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:.grouped)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UINib.init(nibName: "WPImageTitleCell", bundle: nil), forCellReuseIdentifier: WPImageTitleCellID)
        tempTableView.register(UINib.init(nibName: "WPTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPImageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleCellID, for: indexPath) as! WPImageTitleCell
            cell.title_imageView.sd_setImage(with: URL.init(string: infor_model.picurl), placeholderImage: #imageLiteral(resourceName: "icon_defaultAvater"))
            cell.title_label.text = WPPublicTool.stringStar(string: infor_model.phone, headerIndex: 3, footerIndex: 4)
            cell.accessoryType = .checkmark
            return cell
        default:
            let cell: WPTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCellID, for: indexPath) as! WPTitleCell
            cell.title_label.text = "换个新账号登录"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "易购付账号" : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            break
        default:
            self.navigationController?.pushViewController(WPRegisterViewController(), animated: true)
        }
    }
    
    //MARK: - Request
    
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (model) in
            weakSelf?.infor_model = model
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }

}
