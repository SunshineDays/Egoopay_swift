//
//  WPPayPasswordView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/10/31.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

typealias inputPasswordType = (_ password : String) -> Void

class WPPayPasswordView: UIView, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.backgroundColor = UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
        initPayView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var wayName = String()
    
    func initPayView() {
        self.addSubview(self.pay_view)
        self.pay_view.addSubview(title_view)
        self.pay_view.addSubview(password_textField)
        self.pay_view.addSubview(forget_button)
        
        initPwdTextField()
        
        self.password_textField.becomeFirstResponder()
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2) {
            weakSelf?.pay_view.frame = CGRect(x: 0, y: kScreenHeight - (weakSelf?.pay_view.frame.height)!, width: kScreenWidth, height: (weakSelf?.pay_view.frame.height)!)
        }
    }
    
    /**  底部面板 */
    lazy var pay_view: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: WPpopupViewHeight)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var title_view: WPPopupTitleView = {
        let view = WPPopupTitleView()
        view.initInfor(title: "输入支付密码", cancelImage: #imageLiteral(resourceName: "btn_x_content_n"))
        view.title_label.text = "输入支付密码"
        view.cancel_button.addTarget(self, action: #selector(self.dismissView), for: UIControlEvents.touchUpInside)
        return view
    }()
    
    
    /**  返回输入的密码 */
    var inputPassword: inputPasswordType?
    
    var forgetPassword: inputPasswordType?
    
    var payPassword = String()
    
    /**  密码个数 */
    let kDotCount = 6
    /**  密码黑点大小 */
    let kDotSize = CGSize(width: 10, height: 10)
    /**  密码框宽度 */
    let rowHeight = (kScreenWidth - 2 * WPLeftMargin) / 6
    
    let dot_array = NSMutableArray()
    
    lazy var password_textField: UITextField = {
        let tempTextField = UITextField()
        tempTextField.frame = CGRect(x: WPLeftMargin, y: 60 + 30, width: kScreenWidth - 2 * WPLeftMargin, height: self.rowHeight)
        tempTextField.backgroundColor = UIColor.white
        tempTextField.textColor = UIColor.white
        tempTextField.tintColor = UIColor.white
        tempTextField.delegate = self
        tempTextField.autocapitalizationType = UITextAutocapitalizationType.none
        tempTextField.keyboardType = UIKeyboardType.numberPad
        tempTextField.layer.borderColor = UIColor.lineColor().cgColor
        tempTextField.layer.borderWidth = 1
        tempTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        return tempTextField
    }()
    
    lazy var forget_button: UIButton = {
        let tempButton = UIButton()
        tempButton.frame = CGRect(x: kScreenWidth - 100, y: self.password_textField.frame.maxY + 10, width:  100 - WPLeftMargin, height: 40)
        tempButton.setTitle("忘记密码?", for: UIControlState.normal)
        tempButton.setTitleColor(UIColor.themeColor(), for: UIControlState.normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: WPFontDefaultSize)
        tempButton.addTarget(self, action: #selector(self.forgetButtonAction(_:)), for: UIControlEvents.touchUpInside)
        return tempButton
    }()
    
    func initPwdTextField() {
        //生成分割线
        for i in 0 ..< kDotCount - 1 {
            let lineView = UIView()
            lineView.frame = CGRect(x: self.password_textField.frame.minX + CGFloat(i + 1) * self.rowHeight, y: self.password_textField.frame.minY, width: 1, height: self.rowHeight)
            lineView.backgroundColor = UIColor.lineColor()
            self.pay_view.addSubview(lineView)
        }
        
        //生成中间的点
        for i in 0 ..< kDotCount {
            let dotView = UIView()
            dotView.frame = CGRect(x: self.password_textField.frame.minX + (self.rowHeight - CGFloat(kDotCount)) / 2 + CGFloat(i) * self.rowHeight, y: self.password_textField.frame.minY + (self.rowHeight - kDotSize.height) / 2, width: kDotSize.width, height: kDotSize.height)
            dotView.backgroundColor = UIColor.black
            dotView.layer.cornerRadius = kDotSize.width / 2
            dotView.clipsToBounds = true
            dotView.isHidden = true
            self.pay_view.addSubview(dotView)
            self.dot_array.add(dotView)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        else if string.count == 0 {
            return true
        }
        else if (textField.text?.count)! >= kDotCount {
            return false
        }
        else {
            return true
        }
    }
    
    
    // MARK: - Action
    
    //重置显示的点
    @objc func textFieldDidChange(_ textField: UITextField) {
        for i in 0 ..< self.dot_array.count {
            (dot_array[i] as! UIView).isHidden = true
        }
        let count: Int = (textField.text?.count)!
        for i in 0 ..< count {
            (dot_array[i] as! UIView).isHidden = false
        }
        if textField.text?.count == kDotCount {
            payPassword = textField.text!
            dismissView()
            self.inputPassword?(textField.text!)
        }
    }
    
    // MARK: - Action
    
    @objc func forgetButtonAction(_ button: UIButton) {
        dismissView()
        self.forgetPassword?("")
        NotificationCenter.default.post(name: WPNotificationRemovePayInforView, object: nil)
    }
    
    @objc func dismissView() {
        UIApplication.shared.keyWindow?.endEditing(true)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf?.pay_view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 0)
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
}
