//
//  WPUserHomePageController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserHomePageController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib.init(nibName: "WPUserHomePageTitleCell", bundle: nil), forCellReuseIdentifier: WPUserHomePageTitleCellID)
        tableView.register(UINib.init(nibName: "WPUserHomePageContentCell", bundle: nil), forCellReuseIdentifier: WPUserHomePageContentCellID)
        tableView.addSubview(WPThemeColorView())
        
        getUserInforData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.cityName(_:)), name: WPNotificationSelectedAddress, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WPNotificationSelectedAddress, object: nil)
    }
    
    var infor_model = WPUserInforModel()
    
    let content_array = NSMutableArray()
    
    let title_array = ["商户号", "真实姓名", "性别", "地区", "详细地址", "邮箱"]

    /**  选择了哪一行 */
    var selectedRow = Int()
    
    /**  选择的地址模型 */
    var address_model = WPSelectedAddressModel()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.title_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WPUserHomePageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPUserHomePageTitleCellID, for: indexPath) as! WPUserHomePageTitleCell
            cell.model = infor_model
            cell.avater_button.addTarget(self, action: #selector(self.avaterChange), for: .touchUpInside)
            cell.nickname_button.addTarget(self, action: #selector(self.changeNickname), for: .touchUpInside)
            return cell
        }
        else {
            let cell: WPUserHomePageContentCell = tableView.dequeueReusableCell(withIdentifier: WPUserHomePageContentCellID, for: indexPath) as! WPUserHomePageContentCell
            cell.title_label.text = title_array[indexPath.row]
            cell.content_label.text = (content_array[indexPath.row] as! String)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedRow = indexPath.row
            switch indexPath.row {
            case 2:
                sexChange()
            case 3:
                cityChange()
            case 4:
                addressChange()
            case 5:
                emailChange()
            default:
                break
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let cell: WPUserHomePageTitleCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPUserHomePageTitleCell
            cell.avater_button.setBackgroundImage(image, for: UIControlState.normal)
            weakSelf?.postChangeAvater(image: image)
        }
    }
    
    // MArk: - Action
    
    /**  更换头像 */
    @objc func avaterChange() {
        self.alertController(showPhoto: true)
    }
    
    @objc func changeNickname() {
        let vc = WPInputInforController()
        vc.navigationItem.title = "昵称"
        weak var weakSelf = self
        vc.inputInfor = {(inputInfor) -> Void in
            let cell: WPUserHomePageTitleCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPUserHomePageTitleCell
            cell.nickname_button.setTitle(inputInfor, for: .normal)
            weakSelf?.postChangeNickname(nickname: inputInfor)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**  更换性别 */
    func sexChange() {
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: nil, rowOneTitle: "男", rowTwoTitle: "女", rowOne: { (alertAction) in
            weakSelf?.reloadContent(title: alertAction.title!)
            weakSelf?.postChangeSex()
        }) { (alertAction) in
            weakSelf?.reloadContent(title: alertAction.title!)
            weakSelf?.postChangeSex()
        }
    }
    
    //选择地址
    @objc func cityChange() {
        self.navigationController?.pushViewController(WPSelectAddresssController(), animated: true)
    }
    
    @objc func cityName(_ notification: Notification) {
        address_model = notification.userInfo!["model"] as! WPSelectedAddressModel
        self.reloadContent(title: address_model.province + ((address_model.city == "市辖区" || address_model.city == "县") ? address_model.area : address_model.city))
        self.postChangeAddress()
    }
    
    
    /**  详细地址 */
    func addressChange() {
        let vc = WPInputInforController()
        vc.navigationItem.title = "详细地址"
        weak var weakSelf = self
        vc.inputInfor = {(inputInfor) -> Void in
            weakSelf?.reloadContent(title: inputInfor)
            weakSelf?.postChangeAddress()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**  更换邮箱 */
    func emailChange() {
        let vc = WPInputInforController()
        vc.navigationItem.title = "更换邮箱"
        weak var weakSelf = self
        vc.inputInfor = {(inputInfor) -> Void in
            weakSelf?.reloadContent(title: inputInfor)
            weakSelf?.postChangeEmail()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**  刷新内容 */
    func reloadContent(title: String) {
        content_array.replaceObject(at: selectedRow, with: title)
        tableView.reloadRows(at: [IndexPath.init(row: selectedRow, section: 1)], with: UITableViewRowAnimation.none)
    }
    
    // MARK: - Request
    
    
    func initContentArray() {
        address_model.province = infor_model.province
        address_model.city = infor_model.city
        address_model.area = infor_model.area

        let name = infor_model.fullName != "" ? infor_model.fullName : infor_model.userName
        let city = (infor_model.city == "县" || infor_model.city == "市辖区") ? (infor_model.province + infor_model.area) : (infor_model.province + infor_model.city)
        
        
        content_array.removeAllObjects()
        content_array.addObjects(from: [name, String(format: "%ld", infor_model.merchantno), infor_model.sex == 1 ? "男" : "女", city, infor_model.address, infor_model.email])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    /**  获取用户信息 */
    func getUserInforData() {
        weak var weakSelf = self
        WPUserInforModel.loadData(success: { (inforModel) in
            weakSelf?.infor_model = inforModel
            weakSelf?.initContentArray()
        }) { (error) in
            
        }
    }
    
    /**  修改个人头像 */
    func postChangeAvater(image: UIImage) {
        WPDataTool.POSTRequest(url: WPUserChangeAvatarURL, parameters: ["headImg" : WPPublicTool.imageToString(image: image)], success: { (result) in

        }) { (error) in
            
        }
    }
    
    /**  修改昵称 */
    func postChangeNickname(nickname: String) {
        WPDataTool.POSTRequest(url: WPUserNicknameURL, parameters: ["nickName" : nickname], success: { (result) in
            
        }) { (error) in
            
        }
    }
    
    /**  修改性别 */
    func postChangeSex(){
        WPDataTool.POSTRequest(url: WPUserChangeSxeURL, parameters: ["sex" : content_array[2] as! String == "男" ? "1" : "2"], success: { (result) in
            
        }) { (error) in
            
        }
    }
    
    /**  修改地址 */
    func postChangeAddress(){
        let parameter = ["country" : "中国",
                         "province" : address_model.province,
                         "city" : address_model.city,
                         "area" : address_model.area,
                         "address" : content_array[4]]
        WPDataTool.POSTRequest(url: WPUserChangeAddressURL, parameters: parameter, success: { (result) in
            
        }) { (error) in
            
        }
    }
    
    /**  修改邮箱 */
    func postChangeEmail(){
        WPDataTool.POSTRequest(url: WPUserChangeEmailURL, parameters: ["email" : content_array[5]], success: { (result) in
            
        }) { (error) in
            
        }
    }

}
