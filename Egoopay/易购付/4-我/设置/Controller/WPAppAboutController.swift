//
//  WPAppAboutController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPAppAboutController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "关于"
        tableView.reloadData()
        weak var weakSelf = self
        WPShareModel.getData(success: { (shareModel) in
            weakSelf?.shareModel = shareModel
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shareModel = WPShareModel()
    
    var title_array = ["易购付 Egoopay " + WPAppInfor.appVersion(), "关于易购付", "用户协议", "去评价", "版本说明", "分享给朋友"]
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPAppAboutCell", bundle: nil), forCellReuseIdentifier: WPAppAboutCellID)
        tableView.register(UINib.init(nibName: "WPTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.title_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: WPAppAboutCell = tableView.dequeueReusableCell(withIdentifier: WPAppAboutCellID, for: indexPath) as! WPAppAboutCell
            cell.appVersion_label.text = self.title_array[indexPath.row]
            return cell
        }
        else {
            let cell: WPTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCellID, for: indexPath) as! WPTitleCell
            cell.title_label.text = self.title_array[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 130 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            WPInterfaceTool.showWebViewController(url: WPAboutOurWebURL, title: "易购付")
        case 2:
            WPInterfaceTool.showWebViewController(url: WPUserProtocolWebURL, title: "用户使用协议")
        case 3:
            UIApplication.shared.open(URL.init(string: "https://itunes.apple.com/cn/app/%E6%98%93%E8%B4%AD%E4%BB%98/id1240608651?mt=8")!, options: [:], completionHandler: nil)
        case 4:
            self.navigationController?.pushViewController(WPNewVersionController(), animated: true)
        case 5:
            WPShareTool.shareToApp(model: self.shareModel)
        default:
            break
        }
    }

}
