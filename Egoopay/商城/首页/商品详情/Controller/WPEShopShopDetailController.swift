//
//  WPEShopShopDetailController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/16.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPEShopShopDetailController: WPBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentedControl
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  选择数量 */
    var selectNumber = "1"
    
    /**  商品信息模型 */
    var infor_model = WPEShopShopDetailModel()
    
    var isRefreshImage = false
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl.init(items: ["商品详情", "评价"])
        segmentedControl.tintColor = UIColor.themeEShopColor()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentedAction(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var footer_view: WPEShopShopDetailFooterView = {
        let view = WPEShopShopDetailFooterView.init(frame: CGRect.init(x: 0, y: kScreenHeight - WPNavigationHeight - 50, width: kScreenWidth, height: 50))
        view.love_button.addTarget(self, action: #selector(self.loveAction(_:)), for: .touchUpInside)
        view.cart_button.addTarget(self, action: #selector(self.cartAction(_:)), for: .touchUpInside)
        view.addToCart_button.addTarget(self, action: #selector(self.addToCartAction(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 50))
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.contentSize = CGSize.init(width: kScreenWidth * 2, height: kScreenHeight - WPNavigationHeight - 50)
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x >= kScreenWidth ? 1 : 0
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 50), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPEShopShopDetailHeaderCell", bundle: nil), forCellReuseIdentifier: WPEShopShopDetailHeaderCellID)
        tableView.register(WPEShopShopDetailImageCell.classForCoder(), forCellReuseIdentifier: WPEShopShopDetailImageCellID)
        self.scrollView.addSubview(tableView)
        return tableView
    }()
    
    //评价
    lazy var evalutate_tableView: WPEShopShopDetailTableView = {
        let tableView = WPEShopShopDetailTableView.init(frame: CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight - 50))
        self.scrollView.addSubview(tableView)
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : infor_model.imageList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isRefreshImage ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        else {
            let image = image_array[indexPath.row] as? UIImage
            return kScreenWidth * ((image?.size.height)! - 0.5) / (image?.size.width)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WPEShopShopDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: WPEShopShopDetailHeaderCellID, for: indexPath) as! WPEShopShopDetailHeaderCell
            cell.select_button.addTarget(self, action: #selector(self.selectAction), for: .touchUpInside)
            cell.model = infor_model
            return cell
        }
        else {
            let cell: WPEShopShopDetailImageCell = tableView.dequeueReusableCell(withIdentifier: WPEShopShopDetailImageCellID, for: indexPath) as! WPEShopShopDetailImageCell
            cell.content_imageView.image = image_array[indexPath.row] as? UIImage
            return cell
        }
    }
    
    
    // MRRK: - Action
    
    @objc func segmentedAction(_ segment: UISegmentedControl) {
        scrollView.setContentOffset(CGPoint.init(x: kScreenWidth * CGFloat(segment.selectedSegmentIndex), y: 0), animated: true)
    }
    
    //选择商品属性
    @objc func selectAction() {
        let view = WPEShopShopDetailSelectView()
        view.initInfor(array: category_array, model: infor_model, selectDic: select_dic)
        weak var weakSelf = self
        view.eShopShopDetailSelectViewType = {(dic, number) -> Void in
            let cell: WPEShopShopDetailHeaderCell = weakSelf?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPEShopShopDetailHeaderCell
            
            var title = String()
            for d in dic {
                title = title + (d.value as! WPEShopDetailSpecificationProductModel).name + "  "
            }
            cell.select_label.text = title + number + "件"
            weakSelf?.select_dic.addEntries(from: dic as! [AnyHashable : Any])
            weakSelf?.selectNumber = number
        }
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    let select_dic = NSMutableDictionary()
    
    @objc func loveAction(_ button: UIButton) {
        if button.imageView?.image == #imageLiteral(resourceName: "icon_love_love") {
            postLoveShopData(array: [infor_model.product_id])
        }
        else {
            postDeleteLoveData(array: [infor_model.product_id])
        }
    }
    
    @objc func cartAction(_ button: UIButton) {
        let vc = WPEShopShoppingCartController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //添加到购物车
    @objc func addToCartAction(_ button: UIButton) {
        if infor_model.option == 1 && select_dic.count == 0 {
            selectAction()
        }
        else {
            postAddToCartData(product_id: infor_model.product_id, quantity: selectNumber)
        }
    }
    
    func reloadImage(images: NSArray) {
        for _ in 0 ..< images.count {
            image_array.add(#imageLiteral(resourceName: "icon_shopDefaultPic"))
        }
        for i in 0 ..< images.count {
            weak var weakSelf = self
            SDWebImageDownloader.shared().downloadImage(with: URL.init(string: images[i] as! String), options: SDWebImageDownloaderOptions.useNSURLCache, progress: { (a, b, url) in
            }, completed: { (image, data, error, isTrue) in
                weakSelf?.image_array.replaceObject(at: i, with: image ?? #imageLiteral(resourceName: "icon_shopDefaultPic"))
                if weakSelf?.image_array.count == images.count {
                    weakSelf?.isRefreshImage = true
                    weakSelf?.tableView.reloadData()
                }
            })
        }
        
    }
    
    let image_array = NSMutableArray()
    
    // MARK: - Request
    
    /**  获取评价列表 */
    func getEvalutateListData(id: NSInteger) {
        let parameter = ["product_id" : id]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopEvalutateListURL, parameters: parameter, success: { (result) in
            let array: NSMutableArray = WPEShopShopDetailEvaluateModel.mj_objectArray(withKeyValuesArray: result["orders"])
            weakSelf?.evalutate_tableView.eval_array.addObjects(from: array as! [Any])
            weakSelf?.tableViewNoData(tableView: weakSelf?.tableView, image: #imageLiteral(resourceName: "icon_eShop_noResult_look"), title: "暂无评价")
            WPDataTool.endRefresh(tableView: weakSelf?.tableView, array: array)
        }) { (error) in
            
        }
    }
    
    /**  获取商品详情 */
    func getShopDetailData(id: NSInteger) {
        let parameter = ["id" : id]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopCertainURL, parameters: parameter, success: { (result) in
            weakSelf?.infor_model = WPEShopShopDetailModel.mj_object(withKeyValues: result["products"])
            weakSelf?.tableView.reloadData()
            weakSelf?.reloadImage(images: (weakSelf?.infor_model.imageList)!)
            weakSelf?.view.addSubview((weakSelf?.footer_view)!)
        }) { (error) in
            
        }
        getShopDetailSpecificationData(id: id)
        getEvalutateListData(id: id)
        getLoveState(id: id)
    }
    
    /**  获取的属性信息数据 */
    let category_array = NSMutableArray()
    
    func getShopDetailSpecificationData(id: NSInteger) {
        let parameter = ["id" : id]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopCertainSpecificationURL, parameters: parameter, success: { (result) in
            
            weakSelf?.category_array.addObjects(from: WPEShopDetailSpecificationModel.mj_objectArray(withKeyValuesArray: result["options"]) as! [Any])
            
        }) { (error) in
            
        }
    }
    
    //添加到购物车
    func postAddToCartData(product_id: NSInteger, quantity: String) {
        
        let ids_dic = NSMutableDictionary()
        for s in select_dic {
            let key: String = String(format: "%@", s.key as! CVarArg)
            let value: WPEShopDetailSpecificationProductModel = s.value as! WPEShopDetailSpecificationProductModel
            ids_dic.addEntries(from: [key : value.product_option_value_id])
        }
        let data = try?JSONSerialization.data(withJSONObject: ids_dic, options: .prettyPrinted)
        let json = String.init(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let parameter = ["product_id" : product_id,
                         "quantity" : quantity,
                         "options" : json ?? ""] as [String : Any]
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPEShopCartAddURL, parameters: parameter, success: { (result) in
            WPProgressHUD.showSuccess(status: "添加到购物车成功")
        }) { (error) in
            
        }
    }
    
    //获取该商品的收藏状态
    func getLoveState(id: NSInteger) {
        let parameter = ["product_id" : id]
        weak var weakSelf = self
        WPDataTool.GETRequest(url: WPEShopLoveJudgeURL, parameters: parameter, success: { (result) in
            let isDefault: NSInteger = result["wishlist"] as! NSInteger
            weakSelf?.footer_view.love_button.setImage(isDefault == 1 ? #imageLiteral(resourceName: "icon_love_love_selected") : #imageLiteral(resourceName: "icon_love_love"), for: .normal)
        }) { (error) in
            
        }
    }
    
    /**  移入收藏 */
    func postLoveShopData(array: NSMutableArray) {
        let parameter = ["product_ids" : array]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopLoveAddURL, parameters: parameter, success: { (result) in
            weakSelf?.footer_view.love_button.setImage(#imageLiteral(resourceName: "icon_love_love_selected"), for: .normal)
            weakSelf?.footer_view.love_button.setTitle("  已收藏", for: .normal)
        }) { (error) in
            
        }
    }
    
    //取消收藏
    func postDeleteLoveData(array: NSMutableArray) {
        let parameter = ["product_ids" : array]
        weak var weakSelf = self
        WPDataTool.POSTRequest(url: WPEShopLoveDeleteURL, parameters: parameter, success: { (result) in
            weakSelf?.footer_view.love_button.setImage(#imageLiteral(resourceName: "icon_love_love"), for: .normal)
            weakSelf?.footer_view.love_button.setTitle("  收藏", for: .normal)
        }) { (error) in
            
        }
    }
    
}
