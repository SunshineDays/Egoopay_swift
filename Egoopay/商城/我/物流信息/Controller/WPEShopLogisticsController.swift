//
//  WPEShopLogisticsController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/2.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit
import Alamofire

class WPEShopLogisticsController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "物流信息"
        getAliLogisticsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var image_url = String()
    
    /**  订单编号 */
    var order_id = String()
    
    /**  物流信息模型 */
    var logisctics_model = WPEShopLogisticsModel()
    
    let data_array = NSMutableArray()
    
    lazy var header_view: WPEShopLogisticsView = {
        let view = WPEShopLogisticsView()
        view.model = logisctics_model
        view.image_url = image_url
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.header_view
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WPEShopLogisticsCell", bundle: nil), forCellReuseIdentifier: WPEShopLogisticsCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPEShopLogisticsCell = tableView.dequeueReusableCell(withIdentifier: WPEShopLogisticsCellID, for: indexPath) as! WPEShopLogisticsCell

        cell.lineUp_view.isHidden = indexPath.row == 0
        cell.lineDown_view.isHidden = indexPath.row == data_array.count - 1
        cell.sign_imageView.image = indexPath.row == 0 ? #imageLiteral(resourceName: "icon_eShop_logistics_A"): #imageLiteral(resourceName: "icon_eShop_logistics_B")

        cell.title_label.textColor = indexPath.row == 0 ? UIColor.colorConvert(colorString: "4DCC7F") : UIColor.colorConvert(colorString: "9D9D9D")
        cell.time_label.textColor = indexPath.row == 0 ? UIColor.colorConvert(colorString: "4DCC7F") : UIColor.colorConvert(colorString: "9D9D9D")

        let model: WPEShopLogisticsTracesModel = data_array[data_array.count - indexPath.row - 1] as! WPEShopLogisticsTracesModel
        cell.title_label.text = model.AcceptStation
        cell.time_label.text = model.AcceptTime
        
        return cell
    }
    
    func initDataArray(array: NSArray) {
        let model = WPEShopLogisticsTracesModel()
        model.AcceptStation = "卖家已发货"
        self.data_array.add(model)
        self.data_array.addObjects(from: WPEShopLogisticsTracesModel.mj_objectArray(withKeyValuesArray: array) as! [Any])
        tableView.reloadData()
    }
    
    func getAliLogisticsData() {
        let parameter = ["order_info_id" : order_id]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopLogisticsURL, parameters: parameter, success: { (result) in
            weakSelf?.logisctics_model = WPEShopLogisticsModel.mj_object(withKeyValues: result["orders"])
            weakSelf?.initDataArray(array: (weakSelf?.logisctics_model.Traces)!)
        }) { (error) in
            
        }
    }
    

}
