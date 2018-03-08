//
//  WPNewVersionController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/17.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPNewVersionController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "版本说明"
        // Do any additional setup after loading the view.
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .grouped)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPNewVersionCell", bundle: nil), forCellReuseIdentifier: WPNewVersionCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPNewVersionCell = tableView.dequeueReusableCell(withIdentifier: WPNewVersionCellID, for: indexPath) as! WPNewVersionCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel.init(frame: CGRect.init(x: WPLeftMargin, y: 0, width: kScreenWidth - WPLeftMargin * 2, height: 25))
        label.text = "易购付近期主要更新"
        view.addSubview(label)
        return view
    }

}
