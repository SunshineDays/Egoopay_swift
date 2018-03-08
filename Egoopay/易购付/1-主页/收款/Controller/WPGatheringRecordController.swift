//
//  WPGatheringRecordController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/9.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPGatheringRecordController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收款记录"
        // Do any additional setup after loading the view.
        if isToday {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "全部记录", style: .plain, target: self, action: #selector(self.allAction))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_rili"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.selectDate))
        }

        getGatheringRecordData()
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.page_int = 1
            weakSelf?.getGatheringRecordData()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page_int = (weakSelf?.page_int)! + 1
            weakSelf?.getGatheringRecordData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** 是否是今日收入 */
    var isToday = false
    
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
    
    /**  选择的月份 */
    var month_string = String()
    
    /**  收入 */
    var income = Float()
    
    lazy var header_view: WPGatheringRecordHeaderView = {
        let view = WPGatheringRecordHeaderView()
        view.initInfor(title: self.isToday ? "今日收入(元)" : "总收入(元)", money: String(format: "%.2f", self.income))
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = self.header_view
        tableView.register(UINib.init(nibName: "WPGatheringRecordCell", bundle: nil), forCellReuseIdentifier: WPGatheringRecordCellID)
        tableView.addSubview(WPThemeColorView())
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
        let cell: WPGatheringRecordCell = tableView.dequeueReusableCell(withIdentifier: WPGatheringRecordCellID, for: indexPath) as! WPGatheringRecordCell
        cell.model = ((self.content_array[indexPath.section] as! NSArray)[indexPath.row]) as! WPBillInforModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
//        let model: WPBillInforModel = (self.content_array[indexPath.section] as! NSArray)[indexPath.row] as! WPBillInforModel
//        let vc = WPBillDetailController()
////        vc.bill_model = model
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Action
    
    @objc func allAction() {
        self.navigationController?.pushViewController(WPGatheringRecordController(), animated: true)
    }
    
    @objc func selectDate() {
        let vc = WPBillSelectDateController()
        weak var weakself = self
        vc.selectedBillDateType = {(year, month) -> Void in
            weakself?.month_string = month
            weakself?.date_string = year + month
            weakself?.tableView.mj_header.beginRefreshing()
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Request
    func getGatheringRecordData() {
        let parameter = ["curPage" : page_int,
                         "queryDate" : date_string] as [String : Any]
        
        weak var weakSelf = self
        
        WPDataTool.GETRequest(url: isToday ? WPTodayGatheringRecordURL : WPGatheringRecordURL, parameters: parameter, success: { (result) in
            if weakSelf?.page_int == 1 {
                weakSelf?.bill_array.removeAllObjects()
                weakSelf?.content_array.removeAllObjects()
                weakSelf?.date_array.removeAllObjects()
            }
            weakSelf?.income = (weakSelf?.isToday)! ? (result["todayQrIncome"] as? Float)! : (result["qr_income"] as? Float)!
            weakSelf?.header_view.title_label.text = (weakSelf?.isToday)! ? "今日收入(元)" : (weakSelf?.date_string == "" ? "总收入(元)" : ((weakSelf?.month_string)! + "月收入(元)"))
            weakSelf?.header_view.money_label.text = String(format: "%.2f", (weakSelf?.income)!)
            
            let array: NSMutableArray = WPBillInforModel.mj_objectArray(withKeyValuesArray: result[(weakSelf?.isToday)! ? "bill" : "tradeList"] as Any)

            for i in 0 ..< array.count {
                let billModel: WPBillInforModel = array[i] as! WPBillInforModel
                let date = (WPPublicTool.stringToDate(date: billModel.createDate) as NSString).substring(to: 7)
                //获取日期数组
                weakSelf?.date_array.add(date)
                //去掉重复的月份
                let set = NSSet.init(array: weakSelf?.date_array as! [Any])
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
