//
//  WPSelectShopCityController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/3.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSelectedShopCityType = (_ cityName: String) -> Void

class WPSelectShopCityController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(title_view)
        getShopCityData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedShopCityType: WPSelectedShopCityType?

    var data_array = NSMutableArray()
    
    lazy var title_view: WPTitleView = {
        let view = WPTitleView()
        view.title_label.text = "选择城市"
        view.right_button.setTitle("", for: .normal)
        weak var weakSelf = self
        view.leftAndRightButtonType = {(leftButton, rightButton) -> Void in
            weakSelf?.dismiss(animated: true, completion: nil)
        }
        return view
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: WPNavigationHeight, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPTitleCell", bundle: nil), forCellReuseIdentifier: WPTitleCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPTitleCell = tableView.dequeueReusableCell(withIdentifier: WPTitleCellID, for: indexPath) as! WPTitleCell
        cell.title_label.text = data_array[indexPath.row] as? String
        cell.accessoryType = UITableViewCellAccessoryType.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
        self.selectedShopCityType?((data_array[indexPath.row] as? String)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getShopCityData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPCityListURL, parameters: nil, success: { (result) in
            weakSelf?.data_array.addObjects(from: (result["cities"] as? [Any])!)
            weakSelf?.tableView.reloadData()
        }) { (error) in
            
        }
    }

}
