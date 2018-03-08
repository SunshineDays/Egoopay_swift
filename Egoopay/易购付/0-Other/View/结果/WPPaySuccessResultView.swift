//
//  WPPayResultView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPaySuccessResultView: UIView, UITableViewDelegate, UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        UIApplication.shared.statusBarStyle = .default
        self.backgroundColor =  UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title = String()
    
    var money = Float()
    
    var payState = String()
    
    /**
     * title:标题 money:支付金额 payState:支付信息描述
     */
    func initInfor(title: String, money: Float, payState: String) {
        self.title = title
        self.money = money
        self.payState = payState
        self.tableView.reloadData()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25) {
            weakSelf?.tableView.center = CGPoint.init(x: kScreenWidth / 2, y: kScreenHeight / 2)
        }
    }
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPPaySuccessResultCell", bundle: nil), forCellReuseIdentifier: WPPaySuccessResultCellID)
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
        let cell: WPPaySuccessResultCell = tableView.dequeueReusableCell(withIdentifier: WPPaySuccessResultCellID, for: indexPath) as! WPPaySuccessResultCell
        
        cell.typeResult_label.text = title
        cell.Money_label.text = String(format: "%.2f", money) + "元"
        cell.payState_label.text = payState
        
        cell.finish_button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        return cell
    }
    
    @objc func dismissView() {
        UIApplication.shared.statusBarStyle = .lightContent
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.tableView.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
            WPInterfaceTool.popToViewController(popCount: 1)
        }
    }
    
    
}
