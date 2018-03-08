//
//  WPEShopShopDetailSelectView.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/19.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

typealias WPEShopShopDetailSelectViewType = (_ dic: NSMutableDictionary, _ number: String) -> Void

class WPEShopShopDetailSelectView: UIView, UITextFieldDelegate, UIScrollViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initInfor(array: NSArray, model: WPEShopShopDetailModel?, selectDic: NSMutableDictionary?) {
        data_array = array
        if model != nil {
            infor_model = model!
            productID = (model?.product_id)!
        }
        if selectDic != nil {
            select_dic.addEntries(from: selectDic as! [AnyHashable : Any])
        }
        initTitleView()
        initScrollView()
        panpel_view.addSubview(addToCart_button)
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf?.panpel_view.frame = CGRect.init(x: 0, y: kScreenHeight - (weakSelf?.panpelHeight)!, width: kScreenWidth, height: kScreenHeight)
        }
    }
    
    var productID = NSInteger()
    
    /**  返回选中的数据模型 */
    var eShopShopDetailSelectViewType: WPEShopShopDetailSelectViewType?
    
    /**  商品详情模型 */
    var infor_model = WPEShopShopDetailModel()
    
    /**  商品属性的总数组 */
    var data_array = NSArray()
    
    /**  选择的属性ID数组 */
    let ids_dic = NSMutableDictionary()
    
    /**  底部面板高度 */
    var panpelHeight = kScreenHeight * 0.75
    
    /**  按钮图片网址 */
    var imageUrl = String()
    
    // MARK: - 顶部视图
    
    func initTitleView() {
        self.addSubview(cancelTitle_button)
        panpel_view.addSubview(image_button)
        panpel_view.addSubview(price_label)
        panpel_view.addSubview(number_label)
        panpel_view.addSubview(cancel_button)
        panpel_view.addSubview(line_view)
    }
    
    //取消按钮
    lazy var cancelTitle_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - panpelHeight))
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        return button
    }()
    
    //底部面板
    lazy var panpel_view: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight - panpelHeight, width: kScreenWidth, height: panpelHeight))
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        return view
    }()
    
    lazy var image_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 10, y: -20, width: kScreenWidth / 4, height: kScreenWidth / 4))
        button.backgroundColor = UIColor.white
        if imageUrl.count > 0 {
            button.sd_setImage(with: URL.init(string: imageUrl), for: .normal)
        }
        else {
            button.sd_setImage(with: URL.init(string: infor_model.image[0] as! String), for: .normal)
//            button.addTarget(self, action: #selector(self.imageAction), for: .touchUpInside)
        }
        button.layer.cornerRadius = WPCornerRadius
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lineColor().cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    @objc func imageAction() {
        let view = WPEShopShopDetailImageShowView()
        view.initInfor(array: infor_model.image)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    lazy var price_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: image_button.frame.maxX + 10, y: image_button.center.y - 10, width: 200, height: 20))
        label.textColor = UIColor.priceTextColor()
        label.text = String(format: "￥%.2f", infor_model.price)
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()
    
    lazy var number_label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: image_button.frame.maxX + 10, y: image_button.frame.maxY - 30, width: 200, height: 20))
        label.text = String(format: "库存%d件", infor_model.quantity)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var cancel_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 10 - 20, y: 10, width: 20, height: 20))
        button.setImage(#imageLiteral(resourceName: "btn_x_content_n"), for: .normal)
        button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        return button
    }()
    
    lazy var line_view: UIView = {
        let view = UIView(frame: CGRect.init(x: 15, y: image_button.frame.maxY + 15, width: kScreenWidth - 30, height: 0.5))
        view.backgroundColor = UIColor.lineColor()
        return view
    }()
    
    // MARK: - 内容视图
    
    func initScrollView() {
        for i in 0 ..< data_array.count {
            let model: WPEShopDetailSpecificationModel = data_array[i] as! WPEShopDetailSpecificationModel
            initButtons(model: model, originY: listMaxY, type: i)
        }
        initSelectNumberView()
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: line_view.frame.maxY, width: kScreenWidth, height: panpelHeight - line_view.frame.maxY - addToCart_button.frame.size.height))
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.panpel_view.addSubview(scrollView)
        return scrollView
    }()
    
    /**  每个属性的最大y */
    var listMaxY: CGFloat = 0
    
    var listA_array = NSArray()

    var listB_array = NSArray()
    
    func initButtons(model: WPEShopDetailSpecificationModel, originY: CGFloat, type: NSInteger) {
        //第二层数组
        let listArray = NSMutableArray()
        //第二层数组模型
        listArray.addObjects(from: WPEShopDetailSpecificationProductModel.mj_objectArray(withKeyValuesArray: model.product_option_value) as! [Any])
        
        let label = UILabel.init(frame: CGRect.init(x: 15, y: originY + 15, width: 100, height: 20))
        label.text = model.name
        label.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(label)
        
        var startX: CGFloat = 15 //起始X
        var startY: CGFloat = 10 //起始Y
        let buttonHeight: CGFloat = 40 //按钮高度
        
        let view = UIView()
        view.tag = type + 100
        scrollView.addSubview(view)
        
        for i in 0 ..< listArray.count {
            let button = UIButton()
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = WPLineHeight
            button.layer.cornerRadius = WPCornerRadius
            
            let model: WPEShopDetailSpecificationProductModel = listArray[i] as! WPEShopDetailSpecificationProductModel
            
            button.setTitle(model.name, for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.tag = i
            button.addTarget(self, action: #selector(self.selectedAction(_:)), for: .touchUpInside)
            view.addSubview(button)
            
            
            for dic in select_dic {
                if model.product_option_value_id == (dic.value as! WPEShopDetailSpecificationProductModel).product_option_value_id {
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.layer.borderColor = UIColor.themeEShopColor().cgColor
                    button.backgroundColor = UIColor.themeEShopColor()
                }
            }
            
            let dictM = NSMutableDictionary()
            dictM[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 13)
            
            //根据文本长短设置按钮大小
            var titleSize = (model.name as NSString).size(withAttributes: dictM as? [NSAttributedStringKey : Any])
            titleSize.height = 20
            titleSize.width += 20
            
            if startX + titleSize.width + 15 > kScreenWidth {
                startX = 10
                startY = startY + buttonHeight + 10
            }
            button.frame = CGRect.init(x: startX, y: startY, width: titleSize.width, height: buttonHeight)
            startX = button.frame.maxX + 10
            
            view.frame = CGRect.init(x: 0, y: label.frame.maxY, width: kScreenWidth, height: button.frame.maxY)
        }
        listMaxY = view.frame.maxY
    }
    
    // MARK: - 选择购买数量
    func initSelectNumberView() {
        let label = UILabel.init(frame: CGRect.init(x: 15, y: listMaxY + 15, width: 100, height: 28))
        label.text = "购买数量"
        label.font = UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(label)
        scrollView.addSubview(add_button)
        scrollView.addSubview(number_textField)
        scrollView.addSubview(minus_button)
        scrollView.contentSize = CGSize.init(width: kScreenWidth, height: minus_button.frame.maxY + 15 > scrollView.frame.height ? minus_button.frame.maxY + 15 : scrollView.frame.height)
    }
    
    lazy var add_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: kScreenWidth - 15 - 32, y: listMaxY + 15, width: 32, height: 28))
        button.setImage(#imageLiteral(resourceName: "icon_add_add"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = UIColor.lineColor()
        button.layer.cornerRadius = 1
        button.addTarget(self, action: #selector(self.addAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var number_textField: UITextField = {
        let textField = UITextField.init(frame: CGRect.init(x: add_button.frame.minX - 1 - 38, y: listMaxY + 15, width: 38, height: 28))
        textField.text = "1"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.lineColor()
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    lazy var minus_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: number_textField.frame.minX - 1 - 32, y: listMaxY + 15, width: 32, height: 28))
        button.setImage(#imageLiteral(resourceName: "icon_minus_minus"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.backgroundColor = UIColor.lineColor()
        button.layer.cornerRadius = 1
        button.addTarget(self, action: #selector(self.minusAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var addToCart_button: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: panpelHeight - 45, width: kScreenWidth, height: 45))
        button.setTitle("加入购物车", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeEShopColor()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(self.addToCartAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Action
    
    //选择规格
    @objc func selectedAction(_ button: UIButton) {
        for i in 0 ..< (button.superview?.subviews.count)! {
            (button.superview?.subviews[i] as! UIButton).setTitleColor(button.tag == i ? UIColor.white : UIColor.darkGray, for: .normal)
            (button.superview?.subviews[i] as! UIButton).layer.borderColor = button.tag == i ? UIColor.themeEShopColor().cgColor : UIColor.darkGray.cgColor
            (button.superview?.subviews[i] as! UIButton).backgroundColor = button.tag == i ? UIColor.themeEShopColor() : UIColor.clear
        }
        
        let view: UIView = button.superview!
        let model: WPEShopDetailSpecificationModel = data_array[view.tag - 100] as! WPEShopDetailSpecificationModel
//        let key = model.product_option_id
        
        let listArray = NSMutableArray()
        listArray.addObjects(from: WPEShopDetailSpecificationProductModel.mj_objectArray(withKeyValuesArray: model.product_option_value) as! [Any])
        let listModel: WPEShopDetailSpecificationProductModel = listArray[button.tag] as! WPEShopDetailSpecificationProductModel
//        let value = listModel.product_option_value_id
        
        //选择的id字典
        ids_dic.addEntries(from: [String(format: "%d", model.product_option_id) : listModel.product_option_value_id])
        
        price_dic.addEntries(from: [String(format: "%d", model.product_option_id) : listModel.price])
        var totalPrice: Float = 0
        for price in price_dic {
            totalPrice = totalPrice + (price.value as! Float)
        }
        price_label.text = String(format: "￥%.2f", infor_model.price + totalPrice)
        
        title_dic.addEntries(from: [String(format: "%d", model.product_option_id) : listModel.name])
        
        select_dic.addEntries(from: [String(format: "%d", model.product_option_id) : listModel])

    }
    
    let select_dic = NSMutableDictionary()
    
    /**  存放选中的价格字典 */
    let price_dic = NSMutableDictionary()
    
    /**  存放选中的标题字典 */
    let title_dic = NSMutableDictionary()
    
    //增加数量
    @objc func addAction(_ button: UIButton) {
        var number = NSInteger(number_textField.text!)
        number = number! + 1
        number_textField.text = String(format: "%d", number!)
    }
    
    //减少数量
    @objc func minusAction(_ button: UIButton) {
        var number = (NSInteger(number_textField.text!))!
        if number > 1 {
            number = number - 1
        }
        number_textField.text = String(format: "%d", number)
    }
    
    //修改数量
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.text == "" || textField.text == "0" {
            textField.text = "1"
        }
        textField.text = String(format: "%d", (NSInteger(textField.text!))!)
    }
    
    
    
    //添加到购物车
    @objc func addToCartAction() {
        if ids_dic.count != data_array.count {
            WPProgressHUD.showInfor(status: "请选择")
        }
        else {
            postAddToCartData(product_id: productID, quantity: number_textField.text!)
        }
    }
    
    @objc func dismissView() {
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.panpel_view.frame = CGRect.init(x: 0, y: kScreenHeight + 20, width: kScreenWidth, height: (weakSelf?.panpelHeight)!)
            weakSelf?.alpha = 0
            weakSelf?.eShopShopDetailSelectViewType?((weakSelf?.select_dic)!, (weakSelf?.number_textField.text)!)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
    // MARK: - Request
    
    //添加到购物车
    func postAddToCartData(product_id: NSInteger, quantity: String) {
        let data = try?JSONSerialization.data(withJSONObject: ids_dic, options: .prettyPrinted)
        let json = String.init(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let parameter = ["product_id" : product_id,
                         "quantity" : quantity,
                         "options" : json ?? ""] as [String : Any]
        weak var weakSelf = self
        WPProgressHUD.showProgressIsLoading()
        WPDataTool.POSTRequest(url: WPEShopCartAddURL, parameters: parameter, success: { (result) in
            weakSelf?.dismissView()
            WPProgressHUD.showSuccess(status: "添加到购物车成功")
        }) { (error) in
            
        }
    }
}






