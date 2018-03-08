//
//  WPPayInforWayView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/30.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias WPSelectPayWayType = (_ wayName : String) -> Void

typealias WPCancelPayWayType = () -> Void

class WPPayInforWayView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0)
        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.dismissShareView)))
        initPayView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectPayWayType: WPSelectPayWayType?
    var cancelPayWayType: WPCancelPayWayType?
    
    let title_array = ["银行卡支付", "余额支付", "支付宝支付", "微信支付", "QQ钱包支付"]
    let image_array = [#imageLiteral(resourceName: "icon_payWithBankCard"), #imageLiteral(resourceName: "icon_payWithBalance"), #imageLiteral(resourceName: "icon_payWithApliy"), #imageLiteral(resourceName: "icon_payWithWeChat"), #imageLiteral(resourceName: "icon_payWithQQ")]
    
    func initPayView() {
        self.addSubview(self.pay_view)
        self.pay_view.addSubview(title_view)
        self.pay_view.addSubview(tableView)
        tableView.reloadData()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25) {
            weakSelf?.pay_view.frame = CGRect(x: 0, y: kScreenHeight - (weakSelf?.pay_view.frame.height)!, width: kScreenWidth, height: (weakSelf?.pay_view.frame.height)!)
        }
    }
    
    /**  底部面板 */
    lazy var pay_view: UIView = {
        let view = UIView()
        view.frame = CGRect(x: kScreenWidth, y: kScreenHeight - WPpopupViewHeight, width: kScreenWidth, height: WPpopupViewHeight)
        return view
    }()
    
    lazy var title_view: WPPopupTitleView = {
        let view = WPPopupTitleView()
        view.initInfor(title: "选择付款方式", cancelImage: #imageLiteral(resourceName: "icon_goBack_goBack"))
        view.cancel_button.addTarget(self, action: #selector(self.dismissShareView), for: UIControlEvents.touchUpInside)
        return view
    }()

    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0, y: 60, width: kScreenWidth, height: WPpopupViewHeight - 60), style:UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.backgroundColor()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WPImageTitleCell", bundle: nil), forCellReuseIdentifier: WPImageTitleCellID)
        return tableView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPImageTitleCell = tableView.dequeueReusableCell(withIdentifier: WPImageTitleCellID, for: indexPath) as! WPImageTitleCell
        cell.title_imageView.image = image_array[indexPath.row]
        cell.title_label.text = title_array[indexPath.row]
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectPayWayType?(title_array[indexPath.row])
        dismissShareView()
    }
    
    // MARK: - Action
    
    @objc func dismissShareView() {
        cancelPayWayType!()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.pay_view.frame = CGRect(x: kScreenWidth, y: kScreenHeight - WPpopupViewHeight, width: kScreenWidth, height: 0)
//            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
}
