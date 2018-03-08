//
//  WPBaseViewPlainController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/11/22.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPBaseViewPlainController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "   ", style: .plain, target: self, action: nil)
        
        // 统一设置显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // F5F5F9
        self.view.backgroundColor = UIColor.backgroundColor()
        
        if self.navigationController != nil {
            if self.navigationController!.viewControllers.count > 1 {
                let button =   UIButton(type: .system)
                button.frame = CGRect(x:0, y:0, width:65, height:30)
                button.setImage(#imageLiteral(resourceName: "icon_goBack_goBack"), for: .normal)
                button.setTitle("            ", for: .normal)
                button.addTarget(self, action: #selector(backToPrevious), for: .touchUpInside)
                let leftBarBtn = UIBarButtonItem(customView: button)
                
                //用于消除左边空隙，要不然按钮顶不到最前面
                let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spacer.width = -10;
                
                self.navigationItem.leftBarButtonItems = [spacer,leftBarBtn]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //启用滑动返回（swipe back）
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    //返回true表示所有相同类型的手势辨认都会得到处理
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
        UIGestureRecognizer) -> Bool {
        return true
    }
    
    //是否允许手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            //只有二级以及以下的页面允许手势返回
            return self.navigationController!.viewControllers.count > 1
        }
        return true
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var noResultView:WPNoResultView = {
        let view = WPNoResultView()
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: WPTopY, width: kScreenWidth, height: kScreenHeight - WPNavigationHeight), style: .plain)
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200
        self.view.addSubview(tableView)
        return tableView
    }()
    
    /**  调用相机／相册 */
    func alertController(showPhoto : Bool) -> () {
        let imagePicControl = UIImagePickerController()
        imagePicControl.delegate = self
        imagePicControl.allowsEditing = true
        weak var weakSelf = self
        WPInterfaceTool.alertController(title: nil, rowOneTitle: "拍照", rowTwoTitle: showPhoto ? "从相册中选择" : "", rowOne: { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicControl.sourceType = UIImagePickerControllerSourceType.camera
                imagePicControl.cameraDevice = UIImagePickerControllerCameraDevice.rear
                weakSelf?.present(imagePicControl, animated: true, completion: nil)
            }
            else {
                WPProgressHUD.showInfor(status: "请在系统设置中开启权限")
            }
        }) { (alertAction) in
            if alertAction.title != "" {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    imagePicControl.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    weakSelf?.present(imagePicControl, animated: true, completion: nil)
                }
                else {
                    
                }
            }
        }
    }

}
