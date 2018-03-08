
//
//  WPSelectAdderssController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/19.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPSelectAdderssController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "选择地区"

        switch selectedType_int {
        case 1:
            key_string = "provinceName"
            array_string = "citylist"
            getCityData()
        case 2:
            key_string = "cityName"
            array_string = "arealist"
        case 3:
            key_string = "areaName"
        default:
            break
        }
        
        self.header_View.addSubview(title_label)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var data_array = NSArray()
    
    /**  当前界面展示数据类型 */
    var selectedType_int = Int()
    /**  字典的key值 */
    var key_string = String()
    /**  value对应的数组 */
    var array_string = String()
    
    var province_string = String()
    var city_string = String()
    
    lazy var title_label: UILabel = {
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: WPLeftMargin, y: 10, width: WPButtonWidth, height: 30)
        tempLabel.text = self.province_string + "  " + self.city_string
        tempLabel.textColor = UIColor.darkGray
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var header_View: UIView = {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 40)
        tempView.frame.size.height = self.province_string == "" ? 10 : 40
        return tempView
    }()
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.tableHeaderView = self.header_View
        tempTableView.tableFooterView = UIView()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UINib.init(nibName: "WPUserInforsCell", bundle: nil), forCellReuseIdentifier: WPUserInforsCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPUserInforsCell = tableView.dequeueReusableCell(withIdentifier: WPUserInforsCellID, for: indexPath) as! WPUserInforsCell
        cell.title_label.text = (self.data_array[indexPath.row] as! NSDictionary)[key_string] as? String
        cell.accessoryType = UITableViewCellAccessoryType.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedType_int != 3 {
            let vc = WPSelectAdderssController()
            vc.data_array = ((self.data_array[indexPath.row] as! NSDictionary)[array_string] as? NSArray)!
            vc.selectedType_int = selectedType_int + 1
            switch selectedType_int {
            case 1:
                vc.province_string = ((self.data_array[indexPath.row] as! NSDictionary)[key_string] as? String)!
            case 2:
                vc.province_string = self.province_string
                vc.city_string = ((self.data_array[indexPath.row] as! NSDictionary)[key_string] as? String)!
            default:
                break
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            NotificationCenter.default.post(name: WPNotificationSelectedAddress, object: nil, userInfo: ["province" : province_string, "city" : city_string, "area" : ((self.data_array[indexPath.row] as! NSDictionary)[key_string] as? String)!])

//            WPInterfaceTool.popToViewController(controller: WPPopToViewControllerName)
            WPInterfaceTool.popToViewController(navigationController: self.navigationController, popCount: 3)
        }
        
    }

    // MARK: - Data
    func getCityData() {
        let plist_string: String = Bundle.main.path(forResource: "areaArray", ofType: "plist")!
        let plist_array = NSArray.init(contentsOfFile: plist_string)
        self.data_array = plist_array!
    }
    
}
