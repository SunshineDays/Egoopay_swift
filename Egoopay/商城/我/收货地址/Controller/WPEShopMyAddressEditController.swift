//
//  WPEShopMyAddressEditController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/3.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit
import ContactsUI


class WPEShopMyAddressEditController: WPBaseTableViewController, CNContactPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = isAddAddress ? "新增收货地址" : "编辑收货地址"
        self.tableView.register(UINib.init(nibName: "WPEShopMyAddressEditCell", bundle: nil), forCellReuseIdentifier: WPEShopMyAddressEditCellID)
        NotificationCenter.default.addObserver(self, selector: #selector(self.cityName(_:)), name: WPNotificationSelectedAddress, object: nil)
        getAddressListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WPNotificationSelectedAddress, object: nil)
    }
    
    /** 是否是添加收货地址
     *  true:是添加收货地址  false:是编辑收货地址
     */
    var isAddAddress = true
    
    /**  地址模型 */
    var addressEdit_model = WPEShopMyAddressModel()

    /**  选择的地址模型 */
    var address_model = WPSelectedAddressModel()
    
    /**  是否设置为默认收货地址 */
    var isDefault = false
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopMyAddressEditCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyAddressEditCellID, for: indexPath) as! WPEShopMyAddressEditCell
        cell.selectLink_button.addTarget(self, action: #selector(self.selectPeopleAction), for: .touchUpInside)
        cell.city_button.addTarget(self, action: #selector(self.cityAction), for: .touchUpInside)
        cell.confirm_button.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        if !isAddAddress {
            cell.model = addressEdit_model
        }
        return cell
    }
    
    
    // MARK: - CNContactPickerDelegate
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let phoneNumber: CNPhoneNumber = contactProperty.value as! CNPhoneNumber

        let cell: WPEShopMyAddressEditCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEShopMyAddressEditCell

        cell.name_textField.text = contactProperty.contact.familyName + contactProperty.contact.givenName
        cell.phone_textField.text = phoneNumber.stringValue
        
    }
    
    // MARK: - Action
    
    @objc func selectPeopleAction() {
        let store = CNContactStore()
        weak var weakSelf = self
        store.requestAccess(for: CNEntityType.contacts) { (granted, error) in
            if granted {
                let pickerView = CNContactPickerViewController()
                pickerView.delegate = self
                weakSelf?.present(pickerView, animated: true, completion: nil)
            }
            else {
                WPProgressHUD.showInfor(status: "请在系统设置中同意访问通讯录")
            }
        }
    }
    
    @objc func cityAction() {
        self.navigationController?.pushViewController(WPSelectedAddressController(), animated: true)
    }
    
    @objc func cityName(_ notification: Notification) {
        address_model = notification.userInfo!["model"] as! WPSelectedAddressModel
        let cell: WPEShopMyAddressEditCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEShopMyAddressEditCell
        cell.city_label.text = address_model.province + " " + address_model.city + " " + address_model.area
        
    }
    
    
    @objc func confirmAction() {
        let cell: WPEShopMyAddressEditCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEShopMyAddressEditCell
        if cell.name_textField.text?.count == 0 {
            WPProgressHUD.showInfor(status: "请输入收货人姓名")
        }
        else if !WPJudgeTool.validate(mobile: cell.phone_textField.text!) {
            WPProgressHUD.showInfor(status: "请输入正确的手机号码")
        }
        else if cell.city_label.text?.count == 0 {
            WPProgressHUD.showInfor(status: "请选择收货地址")
        }
        else if cell.address_textField.text?.count == 0 {
            WPProgressHUD.showInfor(status: "请输入详细地址")
        }
        else if cell.code_textField.text?.count != 6 {
            WPProgressHUD.showInfor(status: "请输入邮政编码")
        }
        else {
            if isAddAddress{
                postAddAddressData(name: cell.name_textField.text!, code: cell.code_textField.text!, tel: cell.phone_textField.text!, address: cell.address_textField.text!, company: "", isDefault: isDefault ? "1" : "")
            }
            else {
                postEditAddressData(addressID: addressEdit_model.address_id, name: cell.name_textField.text!, code: cell.code_textField.text!, tel: cell.phone_textField.text!, address: cell.address_textField.text!, company: "", isDefault: isDefault ? "1" : "")
            }
        }
    }
    
    // MARK: - Request
    
    //添加收货地址
    func postAddAddressData(name: String, code: String, tel: String, address: String, company: String, isDefault: String) {
        let parameter = ["firstname" : name,
                         "postcode" : code,
                         "telephone" : tel,
                         "country_id" : address_model.provinceID,
                         "zone_id" : address_model.cityID,
                         "city" : address_model.area,
                         "address" : address,
                         "company" : company,
                         "default" : isDefault]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPEShopAddressAddURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "添加成功")
            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
    //修改收货地址
    func postEditAddressData(addressID : NSInteger, name: String, code: String, tel: String, address: String, company: String, isDefault: String) {
        let parameter = ["address_id" : addressID,
                         "firstname" : name,
                         "postcode" : code,
                         "telephone" : tel,
                         "country_id" : address_model.provinceID.count > 0 ? address_model.provinceID : addressEdit_model.country_id,
                         "zone_id" : address_model.cityID.count > 0 ? address_model.cityID : addressEdit_model.zone_id,
                         "city" : address_model.area.count > 0 ? address_model.area : addressEdit_model.city,
                         "address" : address,
                         "company" : company,
                         "default" : isDefault] as [String : Any]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPEShopAddressEditURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "修改成功")
            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
    
    func getAddressListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopAddressListURL, parameters: nil, success: { (result) in
            let array: NSArray = result["address"] as! NSArray
            weakSelf?.isDefault = array.count > 0 ? false : true
        }) { (error) in
            
        }
    }

}
