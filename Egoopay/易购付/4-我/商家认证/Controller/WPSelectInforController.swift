//
//  WPSelectInforController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/28.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSelectCategoryType = (_ categoryModel : WPCategoryListModel) -> Void

class WPSelectInforController: WPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "请选择"
        // Do any additional setup after loading the view.
        getCategoryListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectCategory: WPSelectCategoryType?
    
    var data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.tableViewColor()
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
        let model: WPCategoryListModel = data_array[indexPath.row] as! WPCategoryListModel
        cell.title_label.text = model.name
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
        let model: WPCategoryListModel = data_array[indexPath.row] as! WPCategoryListModel
        self.selectCategory?(model)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Request
    func getCategoryListData() {
        weak var weakSelf = self
        WPCategoryListModel.loadData { (dataArray) in
            weakSelf?.data_array.addObjects(from: dataArray)
            weakSelf?.tableView.reloadData()
        }
    }
    
}
