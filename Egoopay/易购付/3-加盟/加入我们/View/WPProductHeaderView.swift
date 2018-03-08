//
//  WPProductHeaderView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPProductHeaderView: UIView, UITableViewDelegate, UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(inforModel: WPUserInforModel, poundageModel: WPPoundageModel) {
        infor_model = inforModel
        poundage_model = poundageModel
        self.addSubview(tableView)
    }
    
    var infor_model = WPUserInforModel()
    
    var poundage_model = WPPoundageModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth - WPLeftMargin * 2, height: 170), style: .plain)
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPProductTitleCell", bundle: nil), forCellReuseIdentifier: WPProductTitleCellID)
        return tableView
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPProductTitleCell = tableView.dequeueReusableCell(withIdentifier: WPProductTitleCellID, for: indexPath) as! WPProductTitleCell
        cell.inforModel = infor_model
        cell.poundageModel = poundage_model
        return cell
    }

}
