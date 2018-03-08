//
//  WPRemindUserToApproveView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/5.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPRemindUserToApproveView: UIView, UITableViewDataSource, UITableViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.6)
        self.isUserInteractionEnabled = true
        weak var weakSelf = self
        tableView.reloadData()
        UIView.animate(withDuration: 0.30) {
            weakSelf?.tableView.center = CGPoint.init(x: kScreenWidth / 2, y: kScreenHeight / 2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 10, y: kScreenHeight, width: kScreenWidth - 20, height: 330), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(UINib.init(nibName: "WPRemindUserToApproveCell", bundle: nil), forCellReuseIdentifier: WPRemindUserToApproveCellID)
        self.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPRemindUserToApproveCell = tableView.dequeueReusableCell(withIdentifier: WPRemindUserToApproveCellID, for: indexPath) as! WPRemindUserToApproveCell
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        cell.cancel_button.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        return cell
    }

    
    @objc func confirmAction() {
        cancelAction()
        WPInterfaceTool.rootViewController().pushViewController(WPUserApproveNumberController(), animated: true)
    }
    
    @objc func cancelAction() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.20, animations: {
            weakSelf?.tableView.frame = CGRect(x: kScreenWidth, y: kScreenHeight, width: kScreenWidth - 20, height: 330)
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
}
