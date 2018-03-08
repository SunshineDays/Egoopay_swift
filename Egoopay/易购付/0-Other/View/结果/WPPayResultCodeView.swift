//
//  WPPayResultCodeView.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/21.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPPayResultCodeView: UIView, UITableViewDelegate, UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        UIApplication.shared.statusBarStyle = .default
        self.backgroundColor =  UIColor.colorConvert(colorString: "#000000", alpha: 0.4)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var code_model = WPPayCodeModel()
    
    func initInfor(model: WPPayCodeModel) {
        self.code_model = model
        self.tableView.reloadData()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25) {
            weakSelf?.tableView.center = CGPoint.init(x: kScreenWidth / 2, y: kScreenHeight / 2)
        }
    }
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.tableViewColor()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "WPPayCodeCell", bundle: nil), forCellReuseIdentifier: WPPayCodeCellID)
        self.addSubview(tableView)
        return tableView
    }()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPPayCodeCell = tableView.dequeueReusableCell(withIdentifier: WPPayCodeCellID, for: indexPath) as! WPPayCodeCell
        cell.model = code_model
        cell.save_button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        cell.finish_button.addTarget(self, action: #selector(self.dismissView), for: .touchUpInside)
        return cell
    }
    
    @objc func saveImage() {
        let cell: WPPayCodeCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPPayCodeCell
        UIImageWriteToSavedPhotosAlbum(cell.code_imageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject) {
        if didFinishSavingWithError != nil
        {
            WPProgressHUD.showInfor(status: "二维码保存失败")
        }
        else {
            WPProgressHUD.showInfor(status: "二维码保存成功")
        }
    }
    
    @objc func dismissView() {
        UIApplication.shared.statusBarStyle = .lightContent
        weak var weakSelf = self
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.tableView.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
            UIApplication.shared.statusBarStyle = WPJudgeTool.isEShop() ? .default : .lightContent
            WPInterfaceTool.popToViewController(popCount: 1)
        }
    }
    
}
