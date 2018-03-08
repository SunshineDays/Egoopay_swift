//
//  WPSettingController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSettingController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "设置"
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var title_array = [["账号管理", "手机号"], ["安全中心", "密码设置"], ["用户帮助", "意见反馈", "关于"], ["退出登录"]]
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.tableFooterView = UIView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UINib.init(nibName: "WPTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleCellID)
        tempTableView.register(UINib.init(nibName: "WPTitleContentCell", bundle: nil), forCellReuseIdentifier: WPTitleContentCellID)
        tempTableView.register(UINib.init(nibName: "WPTitleCenterCell", bundle: nil), forCellReuseIdentifier: WPTitleCenterCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.title_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.title_array[section] as NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 1 {
            let cell: WPTitleContentCell = tableView.dequeueReusableCell(withIdentifier: WPTitleContentCellID, for: indexPath) as! WPTitleContentCell
            cell.title_label.text = ((self.title_array[indexPath.section] as NSArray)[indexPath.row]) as? String
            cell.content_label.text = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)
            return cell
        }
        else if indexPath.section == self.title_array.count - 1 {
            let cell: WPTitleCenterCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCenterCellID, for: indexPath) as! WPTitleCenterCell
            return cell
        }
        else {
            let cell: WPTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCellID, for: indexPath) as! WPTitleCell
            cell.title_label.text = ((self.title_array[indexPath.section] as NSArray)[indexPath.row]) as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            case 0://账号管理
                self.navigationController?.pushViewController(WPSettingAccountController(), animated: true)
            case 1://手机号
                print("123")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0://安全中心
                self.navigationController?.pushViewController(WPTouchIDController(), animated: true)
            case 1://密码设置
                self.navigationController?.pushViewController(WPPasswordSelectController(), animated: true)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0: //用户帮助
                WPInterfaceTool.showWebViewController(url: WPUserHelpWebURL, title: "用户帮助")
            case 1: //意见反馈
                self.navigationController?.pushViewController(WPFeedbackController(), animated: true)
            case 2: //关于
                self.navigationController?.pushViewController(WPAppAboutController(), animated: true)
            default:
                break
            }
        case 3:
            WPInterfaceTool.alertController(title: "您确定要退出登录吗？", confirmTitle: "确定", confirm: { (alertAction) in
                WPLoadDataModel.getData(success: { (success) in
                    
                })
            }, cancel: { (alertAction) in
                
            })
            
        default:
            break
        }
    }

}
