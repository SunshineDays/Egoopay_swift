//
//  WPBankCardInputInforController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBankCardInputInforController: WPBaseTableViewController, WPIndatePickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加银行卡"
        isCredit = (cardInfor_dic["cardType"] as! String) == "1"
        if isCredit {
            self.tableView.register(UINib.init(nibName: "WPBankCardInputInforCell", bundle: nil), forCellReuseIdentifier: WPBankCardInputInforCellID)
        }
        else {
            self.tableView.register(UINib.init(nibName: "WPBankCardInputInforTwoCell", bundle: nil), forCellReuseIdentifier: WPBankCardInputInforTwoCellID)
        }
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  银行卡信息 */
    var cardInfor_dic = NSDictionary()
    
    /**  是否是信用卡 */
    var isCredit = Bool()
    
    var year = String()
    
    var month = String()

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
        if isCredit {
            let cell: WPBankCardInputInforCell = tableView.dequeueReusableCell(withIdentifier: WPBankCardInputInforCellID, for: indexPath) as! WPBankCardInputInforCell
            cell.type_label.text = cardInfor_dic["bankName"] as! String + " 信用卡"
            cell.hint_button.addTarget(self, action: #selector(self.imageStateAction), for: .touchUpInside)
            cell.validity_button.addTarget(self, action: #selector(self.validityAction), for: .touchUpInside)
            cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
            return cell
        }
        else {
            let cell: WPBankCardInputInforTwoCell = tableView.dequeueReusableCell(withIdentifier: WPBankCardInputInforTwoCellID, for: indexPath) as! WPBankCardInputInforTwoCell
            cell.type_label.text = cardInfor_dic["bankName"] as! String + " 储蓄卡"
            cell.next_button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: - WPIndatePickerViewDelegate
    
    func selectedIndatePicker(year: String, month: String) {
        self.year = year
        self.month = month
        let cell: WPBankCardInputInforCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPBankCardInputInforCell
        cell.validity_button.setTitle(self.month + "/" + (self.year as NSString).substring(from: 2), for: .normal)
        cell.validity_button.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Action
    
    @objc func validityAction() {
        let pickerView = WPIndatePickerView()
        pickerView.pickerViewDelegate = self
        UIApplication.shared.keyWindow?.addSubview(pickerView)
    }
    
    @objc func imageStateAction() {
        let alertController = UIAlertController.init(title: "有效期说明", message: "有效期是打印在信用卡正面卡号下方", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "知道了", style: .cancel, handler: { (alertAction) in
            
        }))
        self.present(alertController, animated: true) {
            
        }
    }
    
    @objc func nextAction() {
        if isCredit {
            let cell: WPBankCardInputInforCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPBankCardInputInforCell
            if cell.validity_button.titleLabel?.text == "请选择有效期" {
                WPProgressHUD.showInfor(status: "请选择有效期")
            }
            else if !WPJudgeTool.validate(mobile: cell.phone_textField.text!) {
                WPProgressHUD.showInfor(status: "手机号码格式错误")
            }
            else {
                postCardInforToValiate(number: cardInfor_dic["cardNumber"] as! String, phone: cell.phone_textField.text!)
            }
        }
        else {
            let cell: WPBankCardInputInforTwoCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPBankCardInputInforTwoCell
            if !WPJudgeTool.validate(mobile: cell.phone_textField.text!) {
                WPProgressHUD.showInfor(status: "手机号码格式错误")
            }
            else {
                postCardInforToValiate(number: cardInfor_dic["cardNumber"] as! String, phone: cell.phone_textField.text!)
            }
        }
    }
    
    // MARK: - Request
    
    /**  验证银行卡信息是否正确 */
    func postCardInforToValiate(number: String, phone: String) {
        let parameter = ["cardNumber" : number,
                         "phone" : phone]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPValiteBankCardInforURL, parameters: parameter as Any as? [String : Any], success: { (success) in
            weakSelf?.getAuthCodeData(phone: phone)
        }) { (error) in
            
        }
    }
    
    /**  获取验证码 */
    func getAuthCodeData(phone: String) {
        weak var weakSelf = self
        WPLoadDataModel.getData(phone: phone, verType: "3") {
            let vc = WPPasswordAuthCodeController()
            vc.cardInfor_dic.addEntries(from: weakSelf?.cardInfor_dic as! [AnyHashable : Any])
            vc.cardInfor_dic.setObject(phone, forKey: "phone" as NSCopying)
            vc.cardInfor_dic.setObject(WPPublicTool.base64EncodeString(string: (weakSelf?.year)!), forKey: "year" as NSCopying)
            vc.cardInfor_dic.setObject(WPPublicTool.base64EncodeString(string: (weakSelf?.month)!), forKey: "month" as NSCopying)
            vc.authCodeType = 0
            vc.phoneNumber = phone
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
    }


}
