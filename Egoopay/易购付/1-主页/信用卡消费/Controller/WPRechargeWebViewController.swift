//
//  WPRechargeWebViewController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPRechargeWebViewController: WPBaseViewController, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        WPProgressHUD.showProgress(status: "提交订单")
        self.navigationItem.title = "订单支付"
        self.view.addSubview(webView)
        weak var weakSelf = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.popToRootViewController))
        
        OperationQueue.main.addOperation {
            weakSelf?.channel_url = ((weakSelf?.channel_url as NSString?)?.substring(from: 19))!
            weakSelf?.channel_url = ((weakSelf?.channel_url as NSString?)?.substring(to: (weakSelf?.channel_url.count)! - 14))!
            weakSelf?.webView.loadHTMLString((weakSelf?.channel_url)!, baseURL: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        WPProgressHUD.dismiss()
    }
    
    /**  通道A */
    var channel_url = String()
    
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        webView.backgroundColor = UIColor.tableViewColor()
        webView.delegate = self
        return webView
    }()
    

    // MARK: - Action
    @objc func popToRootViewController() {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.popToRootViewController(animated: true)
    }

}


class WPRechargeChannelBWebViewController: WPBaseViewController, UIWebViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WPProgressHUD.showProgressIsLoading()
        self.navigationItem.title = "填写信息"
        self.view.addSubview(webView)
        
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_goBack_goBack"), style: .plain, target: self, action: #selector(self.goBackAction))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.popToRootViewController))
        
        weak var weakSelf = self
        OperationQueue.main.addOperation {
            weakSelf?.webView.loadRequest(URLRequest.init(url: URL.init(string: weakSelf?.channel_url ?? "")!))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        WPProgressHUD.dismiss()
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")
        self.title = title == "" ? "填写信息" : title
    }
    
    /**  通道B */
    var channel_url = String()
    
    
    lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        webView.backgroundColor = UIColor.tableViewColor()
        webView.delegate = self
        return webView
    }()
    
    
    // MARK: - Action
    @objc func popToRootViewController() {
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.popToRootViewController(animated: true)
        WPInterfaceTool.popToViewController(popCount: 2)
    }
    
    @objc func goBackAction() {
        let url = webView.request?.url?.absoluteString
        if url == channel_url {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.webView.goBack()
        }
    }
}

