//
//  WPFeedbackController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/8.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPFeedbackController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "意见反馈"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: .plain, target: self, action: #selector(self.postFeedbackData))
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let title_array = ["功能故障或不可用", "用的不爽，我有建议", "其它问题"]
    
    var tip_array = ["你想反馈的问题类型", "请补充详细问题和意见"]
    
    var selectedRow = 0

    var content = String()
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:.grouped)
        tempTableView.backgroundColor = UIColor.tableViewColor()
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.register(UINib.init(nibName: "WPImageTitleCell", bundle: nil), forCellReuseIdentifier: WPImageTitleCellID)
        tempTableView.register(UINib.init(nibName: "WPFeedbackCell", bundle: nil), forCellReuseIdentifier: WPFeedbackCellID)
        self.view.addSubview(tempTableView)
        return tempTableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPImageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleCellID, for: indexPath) as! WPImageTitleCell
            cell.title_imageView.image = indexPath.row == selectedRow ? #imageLiteral(resourceName: "icon_sel_content_s") : #imageLiteral(resourceName: "icon_sel_content_n")
            cell.title_label.text = title_array[indexPath.row]
            return cell
        default:
            let cell: WPFeedbackCell = tableView.dequeueReusableCell(withIdentifier: WPFeedbackCellID, for: indexPath) as! WPFeedbackCell
            cell.textView.becomeFirstResponder()
            cell.textView.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 55 : 130
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tip_array[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            selectedRow = indexPath.row
            tableView.reloadData()
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChangeSelection(_ textView: UITextView) {
        content = textView.text ?? ""
        let cell: WPFeedbackCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! WPFeedbackCell
        cell.number_label.text = String(format: "%ld", textView.text.count) + "/150"
    }
    
    //MARK: - Request
    
    @objc func postFeedbackData() {
        let parameter = ["adviceType" : title_array[selectedRow],
                         "adviceContent" : content]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPUserFeedBackURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "提交成功，感谢您的反馈")
            weakSelf?.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
}
