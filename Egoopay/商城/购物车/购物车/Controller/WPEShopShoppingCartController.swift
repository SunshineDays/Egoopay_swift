//
//  WPEShopShoppingCartController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/25.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopShoppingCartController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "购物车"

        if self.navigationItem.leftBarButtonItem == nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_goBack_goBack"), style: .plain, target: self, action: #selector(self.goBackAction))
            bottomHeight = WPTabBarHeight
        }
        
        self.view.addSubview(cart_view)
        self.view.addSubview(edit_view)
        
//        getEShopCartListData()
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.getEShopCartListData()
        })
        //刷新列表
        NotificationCenter.default.addObserver(self, selector: #selector(getEShopCartListData), name: WPNotificationEShopPostOrderSuccess, object: nil)
        //用户未完成(完成)支付,跳转到订单列表界面
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToOrderLisVc), name: WPNotificationEShopOrderPayUnFinishedPushToOrderList, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pushToOrderLisVc() {
        let vc = WPEShopMyOrderController()
        vc.selectedNumber = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isRefresh {
            getEShopCartListData()
        }
        else {
            isRefresh = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: WPNotificationEShopPostOrderSuccess, object: nil)
        NotificationCenter.default.removeObserver(self, name: WPNotificationEShopOrderPayUnFinishedPushToOrderList, object: nil)
    }
    
    /**  是否刷新数据 */
    var isRefresh = true
    
    /**  选择的总价 */
    var totalMoney = Double()
    
    /**  选择的总数 */
    var totalNumber: NSInteger = 0
    
    /**  根据是否显示TabBar调节UI TableView高度 */
    var bottomHeight: CGFloat = 0
    
    /**  是否是编辑状态 */
    var isEdit = false
    
    let cart_array = NSMutableArray()
    
    //去结算
    lazy var cart_view: WPShoppingCartView = {
        let view = WPShoppingCartView.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - bottomHeight - 55, width: kScreenWidth, height: 55))
        view.isHidden = true
        view.select_button.addTarget(self, action: #selector(self.selectedAllAction(_:)), for: .touchUpInside)
        view.pay_button.addTarget(self, action: #selector(self.payAction), for: .touchUpInside)
        return view
    }()
    
    //编辑
    lazy var edit_view: WPShoppingCartEditView = {
        let view = WPShoppingCartEditView.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - bottomHeight - 55, width: kScreenWidth, height: 55))
        view.isHidden = true
        view.select_button.addTarget(self, action: #selector(self.selectedAllAction(_:)), for: .touchUpInside)
        view.love_button.addTarget(self, action: #selector(self.loveAction), for: .touchUpInside)
        view.delete_button.addTarget(self, action: #selector(self.deleteAction), for: .touchUpInside)
        return view
    }()
    
    //购物车为空
    lazy var cartEmpty_view: WPEShopShoppingCartEmptyView = {
        let view = WPEShopShoppingCartEmptyView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: tableView.frame.size.height))
        view.go_button.addTarget(self, action: #selector(self.goToHomePageAction), for: .touchUpInside)
        tableView.addSubview(view)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - bottomHeight - 55), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.register(UINib.init(nibName: "WPEShopShoppingCartCell", bundle: nil), forCellReuseIdentifier: WPEShopShoppingCartCellID)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - UITableViewDataSoure
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WPEShopShoppingCartCellID, for: indexPath) as! WPEShopShoppingCartCell
        let model = cart_array[indexPath.row] as! WPEShopProductModel
        cell.model = model
        
        cell.select_button.tag = indexPath.row
        cell.select_button.addTarget(self, action: #selector(self.selectedOneAction(_:)), for: .touchUpInside)
        
        cell.minus_button.tag = indexPath.row
        cell.minus_button.addTarget(self, action: #selector(self.minusAction(_:)), for: .touchUpInside)
        
        cell.add_button.tag = indexPath.row
        cell.add_button.addTarget(self, action: #selector(self.addAction(_:)), for: .touchUpInside)
        
        cell.number_textField.tag = indexPath.row
        cell.number_textField.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = cart_array[indexPath.row] as! WPEShopProductModel
        let vc = WPEShopShopDetailController()
        vc.getShopDetailData(id: model.product_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let model = cart_array[textField.tag] as! WPEShopProductModel
        if textField.text == nil || textField.text?.count == 0 {
            model.quantity = 1
        }
        else {
            model.quantity = NSInteger(textField.text!)!
        }
        postChangeCartShopNumberData(cartID: model.cart_id, productID: model.product_id, number: model.quantity)
        totalAction()
    }
    
    // MARK: - Action
    
    //返回易购付
    @objc func goBackAction() {
        WPUserDefaults.userDefaultsSave(key: WPUserDefaults_isEShop, value: nil)
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = kCATransitionMoveIn
        UIApplication.shared.keyWindow?.layer.add(animation, forKey: "animation")
        UIApplication.shared.keyWindow?.rootViewController = WPTabBarController()
        UserDefaults.standard.synchronize()
    }
    
    //去到商城首页
    @objc func goToHomePageAction() {
        self.tabBarController?.selectedIndex = 0
    }

    //编辑
    @objc func editAction() {
        isEdit = !isEdit
        self.navigationItem.rightBarButtonItem?.title = isEdit ? "完成" : "编辑"
        if isEdit {
            edit_view.select_button.setImage(cart_view.select_button.imageView?.image, for: .normal)
        }
        else {
            cart_view.select_button.setImage(edit_view.select_button.imageView?.image, for: .normal)
        }
        cart_view.isHidden = isEdit
        edit_view.isHidden = !isEdit
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
    }
    
    //减少数量
    @objc func minusAction(_ button: UIButton) {
        let model = cart_array[button.tag] as! WPEShopProductModel
        if model.quantity > 1 {
            model.quantity = model.quantity - 1
            postChangeCartShopNumberData(cartID: model.cart_id, productID: model.product_id, number: model.quantity)
            totalAction()
        }
    }
    
    //增加数量
    @objc func addAction(_ button: UIButton) {
        let model = cart_array[button.tag] as! WPEShopProductModel
        if model.quantity <= 99 {
            model.quantity = model.quantity + 1
            postChangeCartShopNumberData(cartID: model.cart_id, productID: model.product_id, number: model.quantity)
            totalAction()
        }
    }
    
    //选中单个商品
    @objc func selectedOneAction(_ button: UIButton) {
        WPInterfaceTool.eShopSelectedOne(button: button, array: cart_array, allButton: isEdit ? edit_view.select_button : cart_view.select_button)
        totalAction()
    }
    
    //选中全部商品
    @objc func selectedAllAction(_ button: UIButton) {
        WPInterfaceTool.eShopSelectedAll(array: cart_array, allButon: button, tableView: tableView)
        totalAction()
    }
    
    //选中商品的总价/数量
    func totalAction() {
        var money = 0.00
        var number = 0
        for i in cart_array {
            let model = i as! WPEShopProductModel
            if model.isSelected == 1 {
                money = money + Double(Float(model.quantity) * model.price)
                number = number + model.quantity
            }
        }
        cart_view.money_label.text = String(format: "合计:￥%.2f", money)
        cart_view.pay_button.setTitle(String(format: "去结算(%d)", number), for: .normal)
        totalMoney = money
        totalNumber = number
    }
    
    //去结算选中的商品
    @objc func payAction() {
        if totalNumber == 0 {
            WPProgressHUD.showInfor(status: "您还没有选择商品哦")
        }
        else {
            postToPayData()
        }
    }
    
    //收藏选中的商品
    @objc func loveAction() {
        let loveArray = NSMutableArray()
        for i in 0 ..< cart_array.count {
            let model = cart_array[i] as! WPEShopProductModel
            if model.isSelected == 1 {
                loveArray.add(model.product_id)
            }
        }
        if loveArray.count == 0 {
            WPProgressHUD.showInfor(status: "请选择商品")
        }
        else {
            postLoveShopData(array: loveArray)
        }
    }
    
    //删除选中的商品
    @objc func deleteAction() {
        let indexPathArray = NSMutableArray()
        let removeArray = NSMutableArray()
        for i in 0 ..< cart_array.count {
            let model = cart_array[i] as! WPEShopProductModel
            if model.isSelected == 1 {
                let indexPath = IndexPath.init(row: i, section: 0)
                indexPathArray.add(indexPath)
                removeArray.add(cart_array[i])                                                                                                                                                                                                                                                                                        
            }
        }
        if removeArray.count == 0 {
            WPProgressHUD.showInfor(status: "请选择商品")
        }
        else {
            postDeleteShopData(array: removeArray, indexPathArray: indexPathArray)
        }
    }
    
    //刷新数据改变购物车状态
    func changeViewConfig(array: NSMutableArray) {
        for i in cart_array {
            let model = i as! WPEShopProductModel
            model.isSelected = 0
        }
        tableView.reloadData()
        cart_view.select_button.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        edit_view.select_button.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        cart_view.money_label.text = "合计:￥0.00"
        cart_view.pay_button.setTitle("去结算(0)", for: .normal)
        cart_view.isHidden = array.count == 0
        edit_view.isHidden = true
        if array.count > 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(self.editAction))
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
        isEdit = false
    }
    
    //判断购物车是否为空
    func showCartEmptyView(array: NSMutableArray) {
        if array.count > 0 {
            cartEmpty_view.isHidden = true
        }
        else {
            cartEmpty_view.isHidden = false
        }
    }
    
    
    //MARK: - Request
    
    //获取购物车列表
    @objc func getEShopCartListData() {
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopCartListURL, parameters: nil, success: { (result) in
            weakSelf?.cart_array.removeAllObjects()
            weakSelf?.cart_array.addObjects(from: WPEShopProductModel.mj_objectArray(withKeyValuesArray: result["products"]) as! [Any])
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.reloadData()
            weakSelf?.showCartEmptyView(array: (weakSelf?.cart_array)!)
            weakSelf?.changeViewConfig(array: (weakSelf?.cart_array)!)
        }) { (error) in
            weakSelf?.tableView.mj_header.endRefreshing()
        }
    }
    
    //去结算
    func postToPayData() {
        let payArray = NSMutableArray()
        for i in cart_array {
            let model = i as! WPEShopProductModel
            if model.isSelected == 1 {
                payArray.add(model)
            }
        }
        let vc = WPEShopInputPayOrderController()
        vc.select_array = payArray
        vc.totalMoney = totalMoney
        vc.totalNumber = totalNumber
        weak var weakSelf = self
        vc.eShopInputPayOrderType = {(isRefresh) -> Void in
            weakSelf?.isRefresh = isRefresh
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //修改商品数量
    func postChangeCartShopNumberData(cartID: NSInteger, productID: NSInteger, number: NSInteger) {
        let parameter = ["cart_id" : cartID,
                         "quantity" : number,
                         "product_id" : ""] as [String : Any]
        
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopCartUpdateURL, parameters: parameter, success: { (result) in
//            WPProgressHUD.showSuccess(status: "success")
            weakSelf?.tableView.reloadData()
        }) { (error) in
//            WPProgressHUD.showSuccess(status: "惜败")
        }
    }
    
    /**  移入收藏 */
    func postLoveShopData(array: NSMutableArray) {
        let parameter = ["product_ids" : array]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopLoveAddURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "收藏成功")
            weakSelf?.changeViewConfig(array: (weakSelf?.cart_array)!)
        }) { (error) in
            
        }
    }
    
    //删除选中的商品
    func postDeleteShopData(array: NSMutableArray, indexPathArray: NSMutableArray) {
        let cart_ids = NSMutableArray()
        for i in 0 ..< array.count {
            let cartID = (array[i] as! WPEShopProductModel).cart_id
            cart_ids.add(cartID)
        }
        let parameter = ["cart_ids" : cart_ids]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopCartRemoveURL, parameters: parameter, success: { (result) in
            weakSelf?.cart_array.removeObjects(in: array as! [Any])
            weakSelf?.tableView.deleteRows(at: indexPathArray as! [IndexPath], with: .automatic)
            weakSelf?.tableView.reloadData()
            weakSelf?.showCartEmptyView(array: (weakSelf?.cart_array)!)
            weakSelf?.changeViewConfig(array: (weakSelf?.cart_array)!)
            weakSelf?.edit_view.select_button.setImage(#imageLiteral(resourceName: "icon_eShopShoppingCart_default"), for: .normal)
        }) { (error) in
            
        }
    }
    
}
