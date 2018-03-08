//
//  WPUserApproveInforsController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/4.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit

class WPUserApproveInforController: WPBaseViewPlainController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "实名认证"
        self.tableView.register(UINib.init(nibName: "WPUserApproveInforCell", bundle: nil), forCellReuseIdentifier: WPUserApproveInforCellID)
        self.tableView.separatorStyle = .none
        self.tableView.addSubview(logo_imageView)
        getUserApproveData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  用户头像 */
    var avater_url = String()
    
    var approve_model = WPUserApproveModel()
    
    lazy var logo_imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: kScreenWidth / 2 - 25, y: -100, width: 50, height: 50))
        imageView.image = #imageLiteral(resourceName: "icon_logo")
        return imageView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WPUserApproveInforCell = tableView.dequeueReusableCell(withIdentifier: WPUserApproveInforCellID, for: indexPath) as! WPUserApproveInforCell
        cell.avater_url = avater_url
        cell.model = approve_model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight - WPNavigationHeight
    }
    
    // MARK: - Request
    
    /**  获取实名认证信息  */
    func getUserApproveData() {
        weak var weakSelf = self
        WPUserApproveModel.loadData(success: { (approveModel) in
            weakSelf?.approve_model = approveModel
            
            weakSelf?.tableView.delegate = self
            weakSelf?.tableView.dataSource = self
            weakSelf?.tableView.reloadData()

            
        }) { (error) in
            
        }
    }
    

}
