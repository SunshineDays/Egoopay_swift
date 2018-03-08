//
//  WPInternationalChargeController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPInternationalChargeController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource, WPIndatePickerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "国际信用卡"
        self.tableView.register(UINib.init(nibName: "WPSelectCardCell", bundle: nil), forCellReuseIdentifier: WPSelectCardCellID)
        self.tableView.register(UINib.init(nibName: "WPInternationalChargeCell", bundle: nil), forCellReuseIdentifier: WPInternationalChargeCellID)
        self.tableView.separatorStyle = .none
        getCreditCardData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  信用卡列表第一个数据的模型 */
    var card_model = WPBankCardModel()
    
    var month = String()
    
    var year = String()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPSelectCardCell = tableView.dequeueReusableCell(withIdentifier: WPSelectCardCellID, for: indexPath) as! WPSelectCardCell
            cell.model = card_model
            return cell
        default:
            let cell: WPInternationalChargeCell = tableView.dequeueReusableCell(withIdentifier: WPInternationalChargeCellID, for: indexPath) as! WPInternationalChargeCell
            cell.validity_button.addTarget(self, action: #selector(self.validityAction), for: .touchUpInside)
            cell.confirm_button.addTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
            return cell
        }
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let vc = WPBankCardListController()
            vc.showCardType = "2"
            vc.navigationItem.title = "请选择国际信用卡"
            weak var weakSelf = self
            vc.selectedCardInfor = {(model) -> Void in
                weakSelf?.card_model = model
                weakSelf?.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)], with: .none)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    // MARK: - WPIndatePickerViewDelegate
    
    func selectedIndatePicker(year: String, month: String) {
        self.year = year
        self.month = month
        let cell: WPInternationalChargeCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! WPInternationalChargeCell
        cell.validity_button.setTitle(self.month + "/" + (self.year as NSString).substring(from: 2), for: .normal)
        cell.validity_button.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Action
    
    @objc func validityAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
        let pickerView = WPIndatePickerView()
        pickerView.pickerViewDelegate = self
        UIApplication.shared.keyWindow?.addSubview(pickerView)
    }
    
    @objc func confirmButtonAction() {
        let cell: WPInternationalChargeCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! WPInternationalChargeCell
        
        if Float(cell.money_textField.text!)! < 100.00 {
            WPProgressHUD.showInfor(status: "单笔取现金额不能少于100元")
        }
        else if cell.cvv_textField.text?.count != 3 {
            WPProgressHUD.showInfor(status: "CVV为3位数字")
        }
        else if cell.validity_button.titleLabel?.text == "请选择有效期" {
            WPProgressHUD.showInfor(status: "请选择有效期")
        }
        else {
            weak var weakSelf = self
            WPPayTool.pay(password: { (password) in
                weakSelf?.postInternationalData(money: cell.money_textField.text!, cvv: cell.cvv_textField.text!)
            })
        }
    }
    
    // MARK: - Request
    
    /**  获取国际信用卡 */
    func getCreditCardData() {
        weak var weakSelf = self
        WPBankCardModel.loadData(clitype: "2", success: { (dataArray) in
            if dataArray.count > 0 {
                weakSelf?.card_model = (dataArray[0] as? WPBankCardModel)!
            }
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()

        }) { (error) in
        }
    }
    
    /**  信用卡充值 */
    func postInternationalData(money: String, cvv: String) {
        let parameter = ["rechargeAmount" : money,
                         "cardId" : card_model.id,
                         "cnv" : WPPublicTool.base64EncodeString(string: cvv),
                         "year" : year,
                         "month" : month] as [String : Any]
        WPProgressHUD.showProgress(status: WPAppName)
        WPDataTool.POSTRequest(url: WPCreditChargeURL, parameters: parameter, success: { (result) in
            WPInterfaceTool.showResultView(title: "充值成功", money: Float(money)!, payState: "国际信用卡充值")
        }) { (error) in
            
        }
    }
}
