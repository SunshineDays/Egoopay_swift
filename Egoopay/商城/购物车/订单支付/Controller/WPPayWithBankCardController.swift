//
//  WPPayWithBankCardController.swift
//  Egoopay
//
//  Created by 易购付 on 2018/1/29.
//  Copyright © 2018年 Egoopay. All rights reserved.
//

import UIKit

class WPPayWithBankCardController: WPBaseViewController, UIWebViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单支付"
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_goBack_goBack"), style: .plain, target: self, action: #selector(self.goBackAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(self.popToCartVc))
        WPProgressHUD.showProgress(status: WPAppName)
        self.webView.delegate = self
        weak var weakSelf = self
        OperationQueue.main.addOperation {
            weakSelf?.webView.loadRequest(URLRequest.init(url: URL.init(string: (weakSelf?.webUrl_string)!)!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        WPProgressHUD.dismiss()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        WPProgressHUD.dismiss()
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")
        self.title = title
    }
    
    var webUrl_string = String()
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        webView.backgroundColor = UIColor.tableViewColor()
        self.view.addSubview(webView)
        return webView
    }()
    
    @objc func popToCartVc() {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: WPNotificationEShopOrderPayUnFinishedPushToOrderList, object: nil)
    }
    
    @objc func goBackAction() {
        let url = webView.request?.url?.absoluteString
        if url == webUrl_string {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.webView.goBack()
        }
    }
}
