//
//  WPEShopMyOrderDetailFooterView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/30.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

//typealias WPEShopMyOrderDetailFooterViewType = (_) -> Void

class WPEShopMyOrderDetailFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.backgroundColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**  订单详情模型 */
    var detail_model: WPEShopMyOrderDetailModel! = nil {
        didSet {
            changeButton()
            right_button.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.greaterThanOrEqualTo(65)
            }
            right_button.setTitle(title_array[0] as? String, for: .normal)
            if title_array.count > 1 {
                left_button.snp.makeConstraints { (make) in
                    make.right.equalTo(right_button.snp.left).offset(-10)
                    make.centerY.equalTo(right_button.snp.centerY)
                    make.height.equalTo(right_button.snp.height)
                    make.width.greaterThanOrEqualTo(65)
                }
                left_button.setTitle(title_array[1] as? String, for: .normal)
            }
        }
    }
    
    func changeButton() {
        switch detail_model.order_status {
        case "待付款":
            title_array = ["去支付", "取消订单"]
        case "待发货":
            title_array = [" 提醒卖家发货 "]
        case "待收货":
            title_array = ["确认收货", "查看物流"]
        case "待评价":
            title_array = ["评价晒单"]
        case "已完成", "已取消":
            title_array = ["查看物流", "删除订单"]
        default:
            break
        }
    }
    
    var title_array = NSArray()
    
    lazy var right_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.themeEShopColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.themeEShopColor().cgColor
        button.layer.borderWidth = 0.8
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(self.goToVc(_:)), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var left_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.8
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(self.goToVc(_:)), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
//    func initButtons() {
//        changeButton()
//        let width = kScreenWidth / 4.5
//        for i in 0 ..< title_array.count {
//            let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - (width + 10) * CGFloat(i + 1), y: 8, width: width, height: 35))
//            button.setTitle(title_array[i] as? String, for: .normal)
//            button.setTitleColor(i == 0 ? UIColor.themeEShopColor() : UIColor.lightGray, for: .normal)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//            button.layer.borderColor = i == 0 ? UIColor.themeEShopColor().cgColor : UIColor.lightGray.cgColor
//            button.layer.borderWidth = 0.8
//            button.layer.cornerRadius = 2
//            button.addTarget(self, action: #selector(self.goToVc(_:)), for: .touchUpInside)
//            self.addSubview(button)
//        }
//    }
    
    @objc func goToVc(_ button: UIButton) {
        switch button.currentTitle! {
        case "去支付":
            let vc = WPEShopPayOrderWithAppController()
            vc.order_model.order_info_id = detail_model.order_info_id
            vc.totalMoney = detail_model.total
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        case "取消订单":
            weak var weakSelf = self
            WPInterfaceTool.alertController(title: "确认取消订单嘛？", confirmTitle: "取消订单", confirm: { (action) in
                weakSelf?.postOrderstatus(orderID: (weakSelf?.detail_model.order_info_id)!, status: "7")
            }, cancel: { (action) in
                
            })
        case " 提醒卖家发货 ":
            WPProgressHUD.showSuccess(status: "已提醒卖家，会尽快安排发货")
        case "确认收货":
            weak var weakSelf = self
            WPInterfaceTool.alertController(title: "您已确认收货？", confirmTitle: "确认收货", confirm: { (action) in
                weakSelf?.postOrderstatus(orderID: (weakSelf?.detail_model.order_info_id)!, status: "6")
            }, cancel: { (action) in
                
            })
        case "查看物流":
            let vc = WPEShopLogisticsController()
            vc.order_id = detail_model.order_info_id
            let array = NSMutableArray()
            array.addObjects(from: WPEShopMyOrderDetailProductModel.mj_objectArray(withKeyValuesArray: detail_model.products) as! [Any])
            let model: WPEShopMyOrderDetailProductModel = array[0] as! WPEShopMyOrderDetailProductModel
            vc.image_url = model.image
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        case "评价晒单":
            let vc = WPEShopMyEvaluateController()
            vc.detail_model = detail_model
            WPInterfaceTool.rootViewController().pushViewController(vc, animated: true)
        case "删除订单":
            weak var weakSelf = self
            WPInterfaceTool.alertController(title: "确认删除该订单？", confirmTitle: "删除", confirm: { (action) in
                weakSelf?.postOrderDelete(orderID: (weakSelf?.detail_model.order_id)!)
            }, cancel: { (action) in
                
            })
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
    
    
}
