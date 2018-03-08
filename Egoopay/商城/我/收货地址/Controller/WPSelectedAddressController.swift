//
//  WPSelectedAddressController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/18.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSelectedAddressType = (_ province: String, _ provinceID: String, _ city: String, _ cityID: String, _ area: String, _ areaID: String) -> Void

class WPSelectedAddressController: WPBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "选择地区"
        
        let plistPath = Bundle.main.path(forResource: "areaForEShop", ofType: "plist")!
        
        province_array = NSArray.init(contentsOfFile: plistPath)!
        
        tableView.separatorStyle = .singleLine
        tableView.register(WPSelectedAddressCell.classForCoder(), forCellReuseIdentifier: WPSelectedAddressCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedAddressType: WPSelectedAddressType?
    
    /**  选择的类型
     * 0:省 1:市 2:县
     */
    var selectType = 0
    
    /**  标题 */
    var headerTitle = String()
    
    var province_array = NSArray()
    
    var city_array = NSArray()
    
    var area_array = NSArray()
    
    /**  选择的地址信息模型 */
    var address_model = WPSelectedAddressModel()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch selectType {
        case 0:
            return province_array.count
        case 1:
            return city_array.count
        case 2:
            return area_array.count
        default:
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WPSelectedAddressCellID, for: indexPath) as! WPSelectedAddressCell
        switch selectType {
        case 0:
            let provinceDic = province_array[indexPath.row] as! NSDictionary
            cell.provinceDic = provinceDic
        case 1:
            let cityDic = city_array[indexPath.row] as! NSDictionary
            cell.cityDic = cityDic
        case 2:
            let areaDic = area_array[indexPath.row] as! NSDictionary
            cell.areaDic = areaDic
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = WPSelectedAddressTitleView()
        view.title_label.text = headerTitle != "" ? headerTitle : "请选择"
        return view
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell: WPSelectedAddressCell = tableView.cellForRow(at: indexPath) as! WPSelectedAddressCell
        
        let vc = WPSelectedAddressController()
        switch selectType {
        case 0:
            let provinceDic: NSDictionary = province_array[indexPath.row] as! NSDictionary
            
            address_model.province = provinceDic["name"] as! String
            address_model.provinceID = provinceDic["id"] as! String
            vc.address_model = address_model
            
            vc.city_array = provinceDic["zones"] as! NSArray

        case 1:
            let cityDic: NSDictionary = city_array[indexPath.row] as! NSDictionary
            
            address_model.city = cityDic["name"] as! String
            address_model.cityID = cityDic["id"] as! String
            vc.address_model = address_model

            vc.area_array = cityDic["city"] as! NSArray
            
        case 2:
            let areaDic: NSDictionary = area_array[indexPath.row] as! NSDictionary
            
            address_model.area = areaDic["name"] as! String
            address_model.areaID = areaDic["id"] as! String
            
            NotificationCenter.default.post(name: WPNotificationSelectedAddress, object: nil, userInfo: ["model" : address_model])
            WPInterfaceTool.popToViewController(popCount: 3)
            return
            
        default:
            break
        }
        vc.selectType = selectType + 1
        vc.headerTitle = headerTitle + cell.title_label.text! + " "
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
