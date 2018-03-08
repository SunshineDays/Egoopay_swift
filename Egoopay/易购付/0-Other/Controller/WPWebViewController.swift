//
//  WPWebViewController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/9/26.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPWebViewController: WPBaseViewController, UIWebViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor()
        WPProgressHUD.showProgress(status: "加载中")
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icon_goBack_goBack"), style: .plain, target: self, action: #selector(self.goBackAction))
        self.webView.delegate = self
        weak var weakSelf = self
        OperationQueue.main.addOperation {
            weakSelf?.webView.loadRequest(URLRequest.init(url: URL.init(string: (weakSelf?.webUrl_string)!)!))
            
        }
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        WPPublicTool.celanCacheAndCookie()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        WPProgressHUD.dismiss()
        let title = webView.stringByEvaluatingJavaScript(from: "document.title")
        self.title = title == "" ? "信用卡申请" : title
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        WPProgressHUD.dismiss()
    }
    
    
    var webUrl_string = String()
    
    lazy var webView: UIWebView = {
        let tempWebView = UIWebView(frame: CGRect(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight))
        tempWebView.backgroundColor = UIColor.tableViewColor()
        self.view.addSubview(tempWebView)
        return tempWebView
    }()
    
    
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
