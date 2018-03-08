//
//  WPBillListController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/6.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

let WPBillListCellID = "WPBillListCellID"

class WPBillListController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "账单"
        
//        let rightBarButtonItemA = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_rili"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.selectDate))
//        let rightBarButtonItemB = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_rili"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.selectPieChartVC))
//
//        self.navigationItem.rightBarButtonItems = [rightBarButtonItemA, rightBarButtonItemB]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_rili"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.self.selectDate))

        getBillListData()
        
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.page_int = 1
            weakSelf?.getBillListData()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page_int = (weakSelf?.page_int)! + 1
            weakSelf?.getBillListData()
        })
        
        
    }
    
    var isshow = true
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    lazy var header_view: WPBillAnnimationView = {
//        let view = WPBillAnnimationView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 200))
//        view.backgroundColor = UIColor.themeColor()
//
//        return view
//    }()
    
    /**  数据请求得到的数组 */
    var bill_array = NSMutableArray()
    
    /**  月份数组 */
    var date_array = NSMutableArray()

    /**  上一个月份的字符串 */
    var lastDate_string = ""
    
    /**  最终结果数组 */
    var content_array = NSMutableArray()
    
    /**  页数 */
    var page_int: Int = 1
    
    /**  选择的时间 */
    var date_string = ""
    
    lazy var tableView: UITableView = {
        let tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPBillListCell", bundle: nil), forCellReuseIdentifier: WPBillListCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.content_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.content_array[section] as? NSArray)?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPBillListCell = tableView.dequeueReusableCell(withIdentifier: WPBillListCellID, for: indexPath) as! WPBillListCell
        cell.model = ((self.content_array[indexPath.section] as! NSArray)[indexPath.row]) as! WPBillInforListModel
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WPBillListHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        headerView.title_label.text = WPPublicTool.StringMonthDate(dateString: (self.date_array[section] as? String)!)
        return headerView
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model: WPBillInforListModel = (self.content_array[indexPath.section] as! NSArray)[indexPath.row] as! WPBillInforListModel
        let vc = WPBillDetailController()
        vc.bill_model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action
    
    @objc func selectPieChartVC() {
        self.navigationController?.pushViewController(WPPieChartViewController(), animated: true)

    }
    
    @objc func selectDate() {
        let vc = WPBillSelectDateController()
        weak var weakself = self
        vc.selectedBillDateType = {(year, month) -> Void in
            weakself?.date_string = year + month
            weakself?.tableView.mj_header.beginRefreshing()
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Request
    func getBillListData() {
        let parameter = ["curPage" : page_int,
                         "queryDate" : date_string] as [String : Any]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPBillURL, parameters: parameter, success: { (result) in
            if weakSelf?.page_int == 1 {
                weakSelf?.bill_array.removeAllObjects()
                weakSelf?.content_array.removeAllObjects()
                weakSelf?.date_array.removeAllObjects()
            }
            let array: NSMutableArray = WPBillInforListModel.mj_objectArray(withKeyValuesArray: result["list"] as Any)
            for i in 0 ..< array.count {
                let billModel: WPBillInforListModel = array[i] as! WPBillInforListModel
                let date = (WPPublicTool.stringToDate(date: billModel.createDate) as NSString).substring(to: 7)
                //获取日期数组
                weakSelf?.date_array.add(date)
                //去掉重复的月份
                let set = NSSet.init(array: weakSelf?.date_array as? [Any] ?? [])
                weakSelf?.date_array = NSMutableArray.init(array: set.allObjects)
                // 日期数组从大到小排序
                weakSelf?.date_array.sort(comparator: { (obj1, obj2) -> ComparisonResult in
                    return (obj2 as! String).compare(obj1 as! String)
                })
                // 账单数组长度 = 日期数组长度
                weakSelf?.content_array[(weakSelf?.date_array.count)! - 1] = []
                // 判断日期是否变化
                if ((weakSelf?.lastDate_string)! == date) && weakSelf?.lastDate_string != "" {
                    // 相同日期的账单数组
                    weakSelf?.bill_array.add(billModel)
                }
                else {
                    // 日期改变，移除数据，重新添加
                    weakSelf?.bill_array.removeAllObjects()
                    weakSelf?.bill_array.add(billModel)
                }
                //记录日期
                weakSelf?.lastDate_string = date
                // 把账单数组按照日期加入数组中
                weakSelf?.content_array.replaceObject(at: (weakSelf?.date_array.count)! - 1, with: weakSelf?.bill_array.mutableCopy() ?? (Any).self)
            }
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_noMessage"), title: nil)
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)

        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }

}
