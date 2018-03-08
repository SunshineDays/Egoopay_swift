//
//  WPPhoneChargeController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/27.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import ContactsUI

let WPPhoneChargeCellID = "WPPhoneChargeCellID"

class WPPhoneChargeController: WPBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, CNContactPickerDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        isFlux = self.navigationItem.title == "手机充值" ? false : true
        getPhoneInforData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  产品编码 */
    var productCode = String()
    
    /**  手机充值：NO 流量充值：YES */
    var isFlux = false
    
    /**  数据数组 */
    var data_array = NSMutableArray()
    
    /**  记录输入的长度 */
    var lastLength = 0
    
    var tel = WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone) ?? ""
    
    var name = "默认号码"
    
    lazy var tel_textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: WPLeftMargin, y: 10, width: kScreenWidth - 100, height: 50))
        textField.placeholder = "请输入手机号码"
        var phone_string = NSMutableString.init(string: WPUserDefaults.userDefaultsRead(key: WPUserDefaults_phone)!)
        phone_string.insert(" ", at: 3)
        phone_string.insert(" ", at: 8)
        textField.text = phone_string as String
        textField.keyboardType = UIKeyboardType.numberPad
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.editTextField(_:)), for: UIControlEvents.editingChanged)
        return textField
    }()
    
    lazy var name_label: UILabel = {
        let label = UILabel(frame: CGRect(x: WPLeftMargin, y: self.tel_textField.frame.maxY, width: 200, height: 30))
        label.text = "默认号码"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var selectPeople_button: UIButton = {
        let button = UIButton(frame: CGRect(x: kScreenWidth - WPLeftMargin - 30, y: 20, width: 30, height: 30))
        button.setBackgroundImage(#imageLiteral(resourceName: "lianxiren"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.selectPeopleAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.name_label.frame.maxY, width: kScreenWidth, height: WPLineHeight))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
    lazy var title_label: UILabel = {
        let label = UILabel(frame: CGRect(x: WPLeftMargin, y: self.line_view.frame.maxY + 20, width: 200, height: 40))
        label.text = self.isFlux ? "充流量" : "充话费"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    lazy var more_label: UILabel = {
        let label = UILabel(frame: CGRect(x: WPLeftMargin, y: 10, width: 200, height: 40))
        label.text = "更多充值"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var more_collectionView: WPClassCollectionView = {
        let collectionView = WPClassCollectionView(frame: CGRect(x: 0, y: self.more_label.frame.maxY, width: kScreenWidth, height: 105))
        collectionView.initData(iconCount: 4, titleArray: ["流量充值"], imageArray: [#imageLiteral(resourceName: "icon_liuliang")])
        collectionView.collectionView.delegate = self
        return collectionView
    }()

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (kScreenWidth - 2 * WPLeftMargin - 20) / 3, height: 70)
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15)
        flowLayout.headerReferenceSize = CGSize(width: kScreenWidth, height: 150.5)
        flowLayout.footerReferenceSize = CGSize(width: kScreenWidth, height: 130)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        return flowLayout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib.init(nibName: "WPPhoneChargeCell", bundle: nil), forCellWithReuseIdentifier: WPPhoneChargeCellID)
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WPPhoneChargeCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPPhoneChargeCellID, for: indexPath) as! WPPhoneChargeCell
        let model: WPPhoneProductModel = data_array[indexPath.row] as! WPPhoneProductModel
        var product = String()
        if isFlux {
            product = model.resultValue >= 1024 ? String(format: "%ldG", model.resultValue / 1024) : String(format: "%ldM", model.resultValue)
        }
        else {
            product = String(format: "%ld", model.resultValue) + "元"
        }
        cell.money_label.text = product
        cell.price_label.text = "售价:" + String(format: "%.2f", model.price) + "元"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            headerView.addSubview(tel_textField)
            headerView.addSubview(name_label)
            headerView.addSubview(selectPeople_button)
            headerView.addSubview(line_view)
            headerView.addSubview(title_label)
            return headerView
        }
        else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            if !self.isFlux {
                footerView.addSubview(more_label)
                footerView.addSubview(more_collectionView)
            }
            return footerView
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        weak var weakSelf = self
        let model: WPPhoneProductModel = data_array[indexPath.row] as! WPPhoneProductModel
        if collectionView == self.collectionView {
            let phone = weakSelf?.tel_textField.text?.replacingOccurrences(of: " ", with: "")
            if WPJudgeTool.validate(mobile: phone!) {
                WPPayTool.payOrderView(tradeType: model.tradeType, productId: model.id, phone : phone!)
            }
            else {
                WPProgressHUD.showInfor(status: "请输入正确的电话号码")
            }
        }
        else {
            switch indexPath.row {
            case 0:
                fluxButtonAction()
            default:
            break
            }
        }
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == #selector(paste(_:)) {
            return false
        }
        return false
    }
    
    //MARK: - Action
    
    @objc func editTextField(_ textField: UITextField) {
        if (textField.text?.count)! > lastLength {
            if textField.text?.count == 4 || textField.text?.count == 9 {
                let text_string = NSMutableString.init(string: textField.text!)
                text_string.insert(" ", at: (textField.text?.count)! - 1)
                textField.text = text_string as String
            }
            if (textField.text?.count)! >= 13 {
                textField.text = (textField.text! as NSString).substring(to: 13)
            }
            lastLength = (textField.text?.count)!
        }
        else if (textField.text?.count)! < lastLength {
            if textField.text?.count == 4 || textField.text?.count == 9 {
                textField.text = (textField.text! as NSString).substring(to: (textField.text?.count)! - 1)
            }
            lastLength = (textField.text?.count)!
        }
        self.tel = (self.tel_textField.text?.replacingOccurrences(of: " ", with: ""))!
        if WPJudgeTool.validate(mobile: self.tel) {
            getPhoneInforData()
        }
        else {
            if textField.text?.count == 13 {
                self.name_label.text = "请输入正确的电话号码"
                self.name_label.textColor = UIColor.red
            }
            else {
                self.name_label.text = ""
                self.name_label.textColor = UIColor.gray
            }
        }
    }
    
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
    
    func fluxButtonAction() {
        let vc = WPPhoneChargeController()
        vc.navigationItem.title = "流量充值"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let phoneNumber: CNPhoneNumber = contactProperty.value as! CNPhoneNumber
        var phone = String()
        phone = (phoneNumber.stringValue as NSString).substring(to: 3) + " " + (phoneNumber.stringValue as NSString).substring(from: 3)
        phone = (phone as NSString).substring(to: 8) + " " + (phone as NSString).substring(from: 8)
        self.tel_textField.text = phone
        self.tel = phoneNumber.stringValue
        self.name = contactProperty.contact.familyName + contactProperty.contact.givenName
        getPhoneInforData()
    }
    
    //MARK : - Request
    
    @objc func getPhoneInforData() {
        let parameter = ["mobile" : tel,
                         "tradeType" : isFlux ? "12" : "11"]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
   
        WPDataTool.GETRequest(url: WPPhoneGetInforURL, parameters: parameter, superview: self.view, view: self.noResultView, success: { (result) in
            WPProgressHUD.dismiss()
            weakSelf?.data_array.removeAllObjects()
            let model: WPPhoneLocationModel = WPPhoneLocationModel.mj_object(withKeyValues: result)
            let location = model.province == model.city ? model.province : model.province + model.city
            weakSelf?.name_label.text = (weakSelf?.name)! + ((weakSelf?.name)!.count > 0 ? "(" : "") + location + model.contractor + ((weakSelf?.name)!.count > 0 ? ")" : "")
            weakSelf?.name_label.textColor = UIColor.gray
            weakSelf?.data_array.addObjects(from: WPPhoneProductModel.mj_objectArray(withKeyValuesArray: model.list) as! [Any])
            weakSelf?.collectionView.reloadData()
        }, networkError: { (button) in
            WPProgressHUD.dismiss()
            button.addTarget(self, action: #selector(self.getPhoneInforData), for: .touchUpInside)
        }) { (error) in
            WPProgressHUD.dismiss()
        }
    }
    
}
