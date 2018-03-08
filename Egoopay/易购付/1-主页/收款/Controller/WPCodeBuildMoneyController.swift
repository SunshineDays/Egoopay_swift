//
//  WPCodeBuildMoneyController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/20.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPBuildCodeMoneyType = (_ urlCode : String, _ money : String, _ isWechat : Bool) -> Void

class WPCodeBuildMoneyController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "设置金额"
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  设置金额返回 */
    var buildCodeMoneyType: WPBuildCodeMoneyType?
    
    /**  记录用户输入的金额 */
    var money = String()
    
    /**  记录用户选择了哪一行 */
    var selectIndex = 1
    
    let image_array = [#imageLiteral(resourceName: "icon_payWithWeChat"), #imageLiteral(resourceName: "icon_payWithApliy")]
    let title_array = ["微信支付", "支付宝支付"]
    
    lazy var tableView: UITableView = {
        var tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "WPInputTextFieldCell", bundle: nil), forCellReuseIdentifier: WPInputTextFieldCellID)
        tableView.register(UINib.init(nibName: "WPImageTitleCell", bundle: nil), forCellReuseIdentifier: WPImageTitleCellID)
        tableView.register(UINib.init(nibName: "WPConfirmButtonCell", bundle: nil), forCellReuseIdentifier: WPConfirmButtonCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1, 2:
            return 50
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPInputTextFieldCell = tableView.dequeueReusableCell(withIdentifier: WPInputTextFieldCellID, for: indexPath) as! WPInputTextFieldCell
            cell.title_label.text = "金额"
            cell.content_textField.placeholder = "请输入收款金额"
            cell.content_textField.becomeFirstResponder()
            cell.content_textField.delegate = self
            cell.content_textField.addTarget(self, action: #selector(self.textFieldAction(_:)), for: UIControlEvents.editingChanged)
            return cell
        case 1, 2:
            let cell: WPImageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleCellID, for: indexPath) as! WPImageTitleCell
            cell.title_imageView.image = image_array[indexPath.section - 1]
            cell.title_label.text = title_array[indexPath.section - 1]
            cell.accessoryType = indexPath.section == selectIndex ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            return cell
        default:
            let cell: WPConfirmButtonCell = tableView.dequeueReusableCell(withIdentifier: WPConfirmButtonCellID, for: indexPath) as! WPConfirmButtonCell
            cell.confirm_button.setTitle("确定", for: UIControlState.normal)
            cell.confirm_button.addTarget(self, action: #selector(self.confirmAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        case 1:
            return 50
        case 2:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        if section == 1 {
            let label = UILabel(frame: CGRect(x: WPLeftMargin, y: 0, width: 150, height: 50))
            label.text = "支付方式"
            view.addSubview(label)
        }
        return view
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section != 0 {
            selectIndex = indexPath.section
            let indexPathA = IndexPath.init(row: 0, section: 1)
            let indexPathB = IndexPath.init(row: 0, section: 2)
            tableView.reloadRows(at: [indexPathA, indexPathB], with: UITableViewRowAnimation.none)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return WPValitePriceTool.validatePrice(textField.text, range: range, replacementString: string)
    }
    
    // MARK: - Action
    
    @objc func textFieldAction(_ textField: UITextField) {
        money = textField.text!
        WPInterfaceTool.changeButtonColor(tableView: tableView, row: 0, section: 3, array: [money])
    }
    
    @objc func confirmAction(_ button: UIButton) {
        if Float(money) == 0 {
            WPProgressHUD.showInfor(status: "请输入充值金额")
        }
        else {
            postMoneyData()
        }
    }
    
    // MARK: - Request

    func postMoneyData() {
        let parameter = ["amount" : money,
                         "payMethod" : selectIndex == 1 ? "2" : "3"]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPCodeWithMoneyURL, parameters: parameter, success: { (result) in
            weakSelf?.buildCodeMoneyType?("", (weakSelf?.money)!, weakSelf?.selectIndex == 1)
            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (error) in

        }
    }
    
}
