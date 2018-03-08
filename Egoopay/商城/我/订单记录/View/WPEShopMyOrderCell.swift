//
//  WPEShopMyOrderCell.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/4.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

let WPEShopMyOrderCellID = "WPEShopMyOrderCellID"

class WPEShopMyOrderCell: UITableViewCell, UICollectionViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        state_label.textColor = UIColor.red
        
        right_button.layer.borderColor = UIColor.themeEShopColor().cgColor
        right_button.layer.borderWidth = 0.5
        right_button.layer.cornerRadius = 1
        right_button.setTitleColor(UIColor.themeEShopColor(), for: .normal)
        right_button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        
        left_button.layer.borderColor = UIColor.darkGray.cgColor
        left_button.layer.borderWidth = 0.5
        left_button.layer.cornerRadius = 1
        left_button.setTitleColor(UIColor.darkGray, for: .normal)
        left_button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var shopName_label: UILabel!
    
    @IBOutlet weak var state_label: UILabel!
    
    @IBOutlet weak var commodity_view: UIView!
    
    @IBOutlet weak var total_label: UILabel!
    
    @IBOutlet weak var right_button: UIButton!
    
    @IBOutlet weak var left_button: UIButton!
    
    var model: WPEShopMyOrderListModel! = nil {
        didSet {
            state_label.text = model.status
            changeButton(status: model.status)
            let status = model.status == "待付款" ? "需付款:" : "实付款:"
            total_label.text = String(format: "共%d件商品 %@￥%.2f", model.amount, status, model.total)
            shop_array.removeAllObjects()
            shop_array.addObjects(from: WPEShopMyOrderListProductsModel.mj_objectArray(withKeyValuesArray: model.products) as! [Any])
            collectionView.reloadData()
        }
    }
    
    func changeButton(status: String) {
        switch status {
        case "待付款":
            right_button.setTitle("去支付", for: .normal)
            left_button.isHidden = true
        case "待发货":
            right_button.setTitle(" 提醒卖家发货 ", for: .normal)
            left_button.isHidden = true
        case "待收货":
            right_button.setTitle("确认收货", for: .normal)
            left_button.setTitle("查看物流", for: .normal)
            left_button.isHidden = false
        case "待评价":
            right_button.setTitle("评价晒单", for: .normal)
            left_button.isHidden = true
        case "已完成", "已取消":
            right_button.setTitle("查看物流", for: .normal)
            left_button.isHidden = true
        default:
            break
        }
    }
    
    
    @objc func buttonAction(_ button: UIButton) {
        switch button.currentTitle! {
        case "去支付":
            let vc = WPEShopPayOrderWithAppController()
            vc.order_model.order_info_id = model.order_info_id
            vc.totalMoney = model.total
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        case "取消订单":
            weak var weakSelf = self
            WPInterfaceTool.alertController(title: "确认取消订单嘛？", confirmTitle: "取消订单", confirm: { (action) in
                weakSelf?.postOrderstatus(orderID: (weakSelf?.model.order_info_id)!, status: "7")
            }, cancel: { (action) in
                
            })
        case " 提醒卖家发货 ":
            WPProgressHUD.showSuccess(status: "已提醒卖家，会尽快安排发货")
        case "确认收货":
            weak var weakSelf = self
            WPInterfaceTool.alertController(title: "您已确认收货？", confirmTitle: "确认收货", confirm: { (action) in
                weakSelf?.postOrderstatus(orderID: (weakSelf?.model.order_info_id)!, status: "6")
            }, cancel: { (action) in
                
            })
        case "查看物流":
            let vc = WPEShopLogisticsController()
            vc.order_id = self.model.order_info_id
            let model: WPEShopMyOrderListProductsModel = shop_array[0] as! WPEShopMyOrderListProductsModel
            vc.image_url = model.image
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        case "评价晒单":
            let vc = WPEShopMyEvaluateController()
            vc.list_model = model
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
//        case "删除订单":
//            weak var weakSelf = self
//            WPInterfaceTool.alertController(title: "确认删除该订单？", confirmTitle: "删除", confirm: { (action) in
//                weakSelf?.postOrderDelete(orderID: (weakSelf?.model.order_id)!)
//            }, cancel: { (action) in
//
//            })
        default:
            break
        }
    }
    
    func postOrderstatus(orderID: String, status: String) {
        let parameter = ["order_info_id" : orderID,
                         "order_status_id" : status,
                         "comment" : ""]
        WPDataTool.POSTRequest(url: WPEShopOrderChangeStatusURL, parameters: parameter, success: { (result) in
            switch status {
            case "6":
                WPProgressHUD.showSuccess(status: "确认收货成功")
            case "7":
                WPProgressHUD.showSuccess(status: "取消订单成功")
            default:
                break
            }
        }) { (error) in
            
        }
    }
    
    
    func postOrderDelete(orderID: String) {
        let parameter = ["order_id" : orderID]
        WPDataTool.POSTRequest(url: WPEShopOrderDeleteURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "删除订单成功")
        }) { (error) in
            
        }
    }
    
    
    /**  订单中商品列表 */
    let shop_array = NSMutableArray()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.commodity_view.frame.size.height), collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "WPEShopMyOrderCollectionCell", bundle: nil), forCellWithReuseIdentifier: WPEShopMyOrderCollectionCellID)
        collectionView.register(UINib.init(nibName: "WPEShopMyOrderOnlyOneCollectionCell", bundle: nil), forCellWithReuseIdentifier: WPEShopMyOrderOnlyOneCollectionCellID)
        self.commodity_view.addSubview(collectionView)
        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    // MARK: - UICollectionViewDataSoure
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        changeItemSize()
        return shop_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        changeItemSize()
        if shop_array.count == 1 {
            let cell: WPEShopMyOrderOnlyOneCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopMyOrderOnlyOneCollectionCellID, for: indexPath) as! WPEShopMyOrderOnlyOneCollectionCell
            let model: WPEShopMyOrderListProductsModel = shop_array[indexPath.row] as! WPEShopMyOrderListProductsModel
            cell.model = model
            cell.number = self.model.amount
            return cell
        }
        else {
            let cell: WPEShopMyOrderCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: WPEShopMyOrderCollectionCellID, for: indexPath) as! WPEShopMyOrderCollectionCell
            let model: WPEShopMyOrderListProductsModel = shop_array[indexPath.row] as! WPEShopMyOrderListProductsModel
            cell.shopModel = model
            return cell
        }
        
    }
    
    func changeItemSize() {
        if shop_array.count == 1 {
            flowLayout.itemSize = CGSize.init(width: self.commodity_view.frame.size.width - 20, height: self.commodity_view.frame.size.height - 20)
        }
        else {
            flowLayout.itemSize = CGSize.init(width: self.commodity_view.frame.size.height - 20, height: self.commodity_view.frame.size.height - 20)
        }
    }
    
    
}
