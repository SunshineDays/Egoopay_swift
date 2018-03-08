//
//  WPBillCoreDataTextController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/2/28.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPBillCoreDataTextController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createCoreData()
//        deleteBillList()
//        getBillListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let content_array = NSMutableArray()
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPBillListCell = tableView.dequeueReusableCell(withIdentifier: WPBillListCellID, for: indexPath) as! WPBillListCell
        let model = content_array[indexPath.row] as! WPBillInforListModel
//        cell.money_label.text = String(format: "%.2f", model.amount)
        cell.model = model
        return cell
    }
    
    // MARK: - Request
    func getBillListData() {
        let parameter = ["curPage" : "1",
                         "queryDate" : ""] as [String : Any]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPBillURL, parameters: parameter, success: { (result) in
            let array: NSMutableArray = WPBillInforListModel.mj_objectArray(withKeyValuesArray: result["list"] as Any)
            weakSelf?.content_array.addObjects(from: array as! [Any])
            weakSelf?.tableView.reloadData()
            
            for i in 0 ..< (weakSelf?.content_array.count)! {
                let model = weakSelf?.content_array[i] as! WPBillInforListModel
                weakSelf?.insertIntoBillList(model: model)
            }
            
        }) { (error) in
            
        }
    }
    

    var billLists = [BillList]()
    
    func createCoreData() {
        // 1、获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // 2、建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillList")
        
        // 3、执行请求
        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                billLists = results as! [BillList]
                print("1111111\n%d", results.count)
                let array = WPBillInforListModel.mj_objectArray(withKeyValuesArray: billLists)
                content_array.addObjects(from: array as! [Any])
                tableView.reloadData()
            }
            
        } catch {
            fatalError("惜败")
        }
    }
    
    /**  添加数据到BillList */
    func insertIntoBillList(model: WPBillInforListModel) {
        
        // 1、获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // 2、建立一个entity
        let entity = NSEntityDescription.entity(forEntityName: "BillList", in: managedObjectContext)
        let billList = NSManagedObject.init(entity: entity!, insertInto: managedObjectContext)
        
        // 3、保存数据到BillList
        billList.setValue(model.orderno, forKey: "orderno")
        billList.setValue(model.tradeTypeName, forKey: "tradeTypeName")
        billList.setValue(model.amount, forKey: "amount")
        billList.setValue(model.tradeType, forKey: "tradeType")
        billList.setValue(model.inPaystate, forKey: "inPaystate")
        billList.setValue(model.createDate, forKey: "createDate")
        billList.setValue(model.payStateName, forKey: "payStateName")

        // 4、保存entity到托管对象中，如果保存失败，进行处理
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("无法保存")
        }
        
        // 5、保存到数组，更新UI
        //        billListModel.append(billList)
        
    }
    
    func deleteBillList() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillList")
        
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest) as! [BillList]
            print("2222\n%d", fetchedObjects.count)
            for bill: BillList in fetchedObjects {
                managedObjectContext.delete(bill)
//                appDelegate.saveContext()
                try managedObjectContext.save()
            }
            
            let fetchedObjectsA = try managedObjectContext.fetch(fetchRequest) as! [BillList]
            print("3333\n%d", fetchedObjectsA.count)
            
        } catch {
            fatalError("删除惜败")
        }
    }

}
