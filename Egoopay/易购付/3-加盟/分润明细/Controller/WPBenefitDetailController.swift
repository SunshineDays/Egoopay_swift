//
//  WPBenefitDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBenefitDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_rili"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.selectDate))

        showTypeToRequest()
        
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.page_int = 1
            weakSelf?.showTypeToRequest()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.page_int = (weakSelf?.page_int)! + 1
            weakSelf?.showTypeToRequest()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTypeToRequest() {
        switch showType {
        case 1:
            getBenefitListData()
            self.navigationItem.title = "分润明细"
        case 2:
            getReferBenefitListData()
            self.navigationItem.title = "分润明细"
        case 3:
            getBenefitDetailTodayData()
            self.navigationItem.title = "今日分润"
            self.navigationItem.rightBarButtonItem = nil
        default:
            break
        }
    }
    
    /**
     *  1:全部分润 2:每个邀请的人的分润 3:今日分润
     */
    var showType = 1
    
    /**  邀请的人的模型 */
    var referModel = WPInvitingPeopleModel()
    
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
        let tableView = UITableView (frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.tableViewColor()
//        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPBenfitsDetailCell", bundle: nil), forCellReuseIdentifier: WPBenfitsDetailCellID)
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
        let cell: WPBenfitsDetailCell = tableView.dequeueReusableCell(withIdentifier: WPBenfitsDetailCellID, for: indexPath) as! WPBenfitsDetailCell
        cell.model = ((self.content_array[indexPath.section] as! NSArray)[indexPath.row]) as! WPBenefitDetailModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return showType == 3 ? 0 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = WPBillListHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        headerView.title_label.text = WPPublicTool.StringMonthDate(dateString: (self.date_array[section] as? String)!)
        return headerView
    }
    
    // MARK: - Action
    
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
    
    // 获取今日分润
    func getBenefitDetailTodayData() {
        let parameter = ["curPage" : page_int]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPProfitDetailTodayURL, parameters: parameter, success: { (result) in
            let request_array: NSArray = WPBenefitDetailModel.mj_objectArray(withKeyValuesArray: result["list"])
            weakSelf?.resultArray(requestArray: request_array)
        }) { (error) in
            
        }
    }
    
    //  获取全部分润记录
    func getBenefitListData() {
        let parameter = ["curPage" : page_int,
                         "queryDate" : date_string] as [String : Any]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPProfitDetailURL, parameters: parameter, success: { (result) in
            let request_array: NSArray = WPBenefitDetailModel.mj_objectArray(withKeyValuesArray: result["benefitDetails"])
            weakSelf?.resultArray(requestArray: request_array)
        }) { (error) in
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
    
    //  获取单个邀请的人的分润记录
    func getReferBenefitListData() {
        let parameter = ["curPage" : page_int,
                         "queryDate" : date_string,
                         "merNo" : referModel.merNo] as [String : Any]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPProfitDetailRefersURL, parameters: parameter, success: { (result) in
            let request_array: NSArray = WPBenefitDetailModel.mj_objectArray(withKeyValuesArray: result["benefitDetails"])
            weakSelf?.resultArray(requestArray: request_array)
        }) { (error) in
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
    
    
    func resultArray(requestArray: NSArray) {
        if page_int == 1 {
            bill_array.removeAllObjects()
            content_array.removeAllObjects()
            date_array.removeAllObjects()
        }
        
        for i in 0 ..< requestArray.count {
            let billModel: WPBenefitDetailModel = requestArray[i] as! WPBenefitDetailModel
            let date = (WPPublicTool.stringToDate(date: billModel.createTime) as NSString).substring(to: 7)
            //获取日期数组
            date_array.add(date)
            //去掉重复的月份
            let set = NSSet.init(array: date_array as? [Any] ?? [])
            date_array = NSMutableArray.init(array: set.allObjects)
            
            // 日期数组从大到小排序
            date_array.sort(comparator: { (obj1, obj2) -> ComparisonResult in
                return (obj2 as! String).compare(obj1 as! String)
            })
            
            // 账单数组长度 = 日期数组长度
            content_array[date_array.count - 1] = []
            
            // 判断日期是否变化
            if lastDate_string == date && lastDate_string != "" {
                // 相同日期的账单数组
                bill_array.add(billModel)
            }
            else {
                // 日期改变，移除数据，重新添加
                bill_array.removeAllObjects()
                bill_array.add(billModel)
            }
            
            //记录日期
            lastDate_string = date
            
            // 把账单数组按照日期加入数组中
            content_array.replaceObject(at: date_array.count - 1, with: bill_array.mutableCopy())
        }
        self.tableViewNoData(tableView: tableView, image: #imageLiteral(resourceName: "icon_noBenefit"), title: nil)
        WPDataTool.endRefresh(tableView: tableView, array: requestArray)
    }
    

}
