//
//  WPEShopApplySalesReturnController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/15.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopApplySalesReturnController: WPBaseViewController, UITableViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "申请退货"
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let data_array = NSMutableArray()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib.init(nibName: "WPEShopMyOrderDetailCommodityCell", bundle: nil), forCellReuseIdentifier: WPEShopMyOrderDetailCommodityCellID)
        tableView.register(UINib.init(nibName: "WPEShopApplySalesReturnCell", bundle: nil), forCellReuseIdentifier: WPEShopApplySalesReturnCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WPEShopMyOrderDetailCommodityCell = tableView.dequeueReusableCell(withIdentifier: WPEShopMyOrderDetailCommodityCellID, for: indexPath) as! WPEShopMyOrderDetailCommodityCell
            return cell
        default:
            let cell: WPEShopApplySalesReturnCell = tableView.dequeueReusableCell(withIdentifier: WPEShopApplySalesReturnCellID, for: indexPath) as! WPEShopApplySalesReturnCell
            cell.collectionView.delegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! WPEShopApplySalesReturnCell
        switch indexPath.row {
        case cell.image_array.count - 1:
            if indexPath.row == 3 {
                WPProgressHUD.showInfor(status: "最多上传3张照片")
            }
            else {
                self.alertController(showPhoto: true)
            }
        default:
            WPInterfaceTool.alertController(title: "删除此照片", confirmTitle: "删除", confirm: { (action) in
                cell.image_array.removeObject(at: cell.image_array.count - indexPath.row - 1)
                cell.collectionView.reloadData()
            }, cancel: { (action) in
                
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let cell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! WPEShopApplySalesReturnCell
            cell.image_array.add(image)
            if cell.image_array.count == 4 {
                
            }
            cell.collectionView.reloadData()
        }
    }
    

}
